import 'package:flutter/material.dart';
import 'package:ragbot_app/Models/question.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Services/database_service.dart';

class QuizController extends ChangeNotifier {
  final DatabaseService dbService = DatabaseService();

  final Quiz _quiz;
  Quiz get quiz => _quiz;

  List<Question> _questions = [];
  List<Question> get questions => _questions;

  bool _questionsLoaded = false;
  bool get questionsLoaded => _questionsLoaded;

  bool _quizStarted = false;
  bool get quizStarted => _quizStarted;
  set quizStarted(bool value) {
    _quizStarted = value;
    notifyListeners();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  QuizController(this._quiz);

  Future<List<Question>> loadQuestions() async {
    _questions = await dbService.getQuestionsForQuiz(_quiz.quizId!);
    _questionsLoaded = true;
    notifyListeners();
    return _questions;
  }

  void startQuiz() async {
    _questions = await dbService.getQuestionsForQuiz(quiz.quizId!);

    if (_questions.isNotEmpty) {
      _quizStarted = true;
      notifyListeners();
    }
  }

  void navigateToNextQuestion() {}
  void navigateToPreviousQuestion() {}
  void submitQuiz() {}

  showClosingQuizDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); //pop dialog
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop(); //pop dialog
        Navigator.of(context).pop(); //pop quiz
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Leaving quiz", style: TextStyle(fontSize: 20)),
      content: const Text(
        "If you leave now, all your answers will be lost. Are you sure you want to exit?",
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
