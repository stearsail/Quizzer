import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ragbot_app/Controllers/stream_controller.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Services/database_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class UploaderViewController extends ChangeNotifier {
  final DatabaseService dbService = DatabaseService();
  late PanelController panelController = PanelController();
  final TextEditingController titleInputController = TextEditingController();
  late Quiz? generatedQuiz;

  bool _isButtonEnabled = false;
  bool get isButtonEnabled => _isButtonEnabled;
  set isButtonEnabled(bool isButtonEnabled) {
    _isButtonEnabled = isButtonEnabled;
    notifyListeners();
  }

  String? _textErrorMessage;
  String? get textErrorMessage => _textErrorMessage;
  set textErrorMessage(String? textErrorMessage) {
    _textErrorMessage = textErrorMessage;
    notifyListeners();
  }

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;
  set isProcessing(bool isProcessing) {
    _isProcessing = isProcessing;
    notifyListeners();
  }

  bool _serverRunning = true;
  bool get serverRunning => _serverRunning;
  set serverRunning(bool serverRunning){
    _serverRunning = serverRunning;
    notifyListeners();
  }

  bool _fileUploaded = false;
  bool get fileUploaded => _fileUploaded;
  set fileUploaded(bool fileUploaded) {
    _fileUploaded = fileUploaded;
    notifyListeners();
  }

  late String _quizTitle;
  String get quizTitle => _quizTitle;
  set quizTitle(String quizTitle) {
    _quizTitle = quizTitle;
  }

  late List<Question> _currentQuiz;
  List<Question> get currentQuiz => _currentQuiz;
  set currentQuiz(List<Question> currentQuiz) {
    _currentQuiz = currentQuiz;
  }

  String? uploadedFilePath = '';
  final String _uri = "http://10.0.2.2:8000";
  List<String>? quizTitles;

  UploaderViewController() {
    titleInputController.addListener(validateTitleInput);
    GlobalStreams.deletedQuizStream.listen((quiz) {
      quizTitles!.remove(quiz.title.toLowerCase());
    });
  }

  Future<void> initQuizTitles() async {
    var quizzes = await dbService.getAllQuizzes();
    quizTitles = quizzes.map((quiz) => quiz.title.toLowerCase()).toList();
  }

  void validateTitleInput() async {
    if (quizTitles == null || quizTitles!.isEmpty) await initQuizTitles();
    String input = titleInputController.text;
    if (input.isEmpty || input.length < 3) {
      textErrorMessage = "Title must be at least 3 characters long";
      isButtonEnabled = false;
    } else if (input.length > 35) {
      textErrorMessage = "Title cannot have more than 35 characters";
      isButtonEnabled = false;
    } else if (quizTitles!.contains(input.toLowerCase())) {
      textErrorMessage = "The same title already exists";
      isButtonEnabled = false;
    } else {
      textErrorMessage = null;
      isButtonEnabled = true;
    }
    notifyListeners();
  }

  void uploadFile() async {
    //select file to upload
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        dialogTitle: "Select .pdf file",
        allowMultiple: false,
        allowedExtensions: ['pdf'],
        lockParentWindow: false);
    if (result != null) {
      uploadedFilePath = result.files.first.path;
      await _uploadFileToServer();
    }
  }

  Future<void> getServerStatus() async {
  Uri statusUri = Uri.parse('$_uri/health-check');
  try {
    // Attempt to fetch the health-check endpoint
    http.Response response = await http.get(statusUri).timeout(const Duration(seconds: 1));
    serverRunning = response.statusCode == 200;
  } catch (e) {
    serverRunning = false;
  } finally {
  }
}

  Future<void> _uploadFileToServer() async {
    await getServerStatus();
    if(!serverRunning) return;
    isProcessing = true;

    //upload file to fastapi endpoint
    //define uri and multipart request
    Uri uploadUri = Uri.parse('$_uri/upload-pdf');
    http.MultipartRequest request = http.MultipartRequest('POST', uploadUri);

    //attach file to request {'filename' : '<the path>'}
    request.files.add(await http.MultipartFile.fromPath('file', uploadedFilePath!));

    //send request
    http.StreamedResponse streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      //is successful
      fileUploaded = true;
      var response = await http.Response.fromStream(streamedResponse);
      String responseBody = response.body;
      var quiz = json.decode(responseBody);
      quizTitle = _capitalizeWords(titleInputController.text.trim());
      quizTitles!.add(quizTitle.toLowerCase());
      await storeQuiz(quiz, quizTitle, uploadedFilePath!.split('/').last);
    } else {
      //temporar
      fileUploaded = true;
      uploadedFilePath = "error";
    }
    isProcessing = false;
  }

  Future<void> storeQuiz(String decodedJson, String quizTitle, String quizSourceFile) async {
    Quiz newQuiz = Quiz(title: quizTitle, sourceFile: quizSourceFile);
    int quizId = await dbService.insertQuiz(newQuiz);
    newQuiz.quizId = quizId;
    GlobalStreams.addQuiz(
        newQuiz); // use Global streamController to send new quiz for AnimatedList update in mainScreenController
    generatedQuiz = newQuiz; //save current quiz
    print("Inserted new quiz with ID: $quizId");
    await storeGeneratedQuestions(decodedJson, quizId);
    currentQuiz = await dbService.getQuestionsForQuiz(quizId);
  }

  Future<void> storeGeneratedQuestions(String jsonData, int quizId) async {
    var questionData = json.decode(jsonData)
        as List<dynamic>; // json list is decoded into dart list of json objects

    for (var questionJson in questionData) {
      if (!questionJson.isEmpty) {
        // deals with case when API response contains an empty json (where questions couldn't be generated)
        Question newQuestion = Question.fromJson(questionJson, quizId);
        var questionId = await dbService.insertQuestion(newQuestion);
        print("New question inserted, ID: $questionId part of Quiz: $quizId");
      }
    }
  }

  String _capitalizeWords(String text) {
    List<String> words = text.split(' ');
    String capitalizedText = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word;
    }).join(' ');

    return capitalizedText;
  }

  void resetController() {
    // Reset file-related flags
    fileUploaded = false;
    isProcessing = false;
    serverRunning = true;
    uploadedFilePath = null;

    // Reset UI-related fields
    _isButtonEnabled = false;
    _textErrorMessage = null;

    // Reset the quiz and questions
    _quizTitle = '';
    _currentQuiz = [];
    generatedQuiz = null;

    // Clear the text field's content
    titleInputController.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    titleInputController.removeListener(validateTitleInput);
    titleInputController.dispose();
    super.dispose();
  }
}
