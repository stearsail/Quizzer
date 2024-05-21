import 'package:flutter/material.dart';
import 'package:ragbot_app/Controllers/stream_controller.dart';
import 'package:ragbot_app/Models/choice.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Services/database_service.dart';

class QuizController extends ChangeNotifier {
  final DatabaseService dbService = DatabaseService();

  Quiz _quiz;
  Quiz get quiz => _quiz;
  set quiz(Quiz value) {
    _quiz = value;
    notifyListeners();
  }

  bool _quizStarted = false;
  bool get quizStarted => _quizStarted;
  set quizStarted(bool value) {
    _quizStarted = value;
    notifyListeners();
  }

  bool _quizEnded = false;
  bool get quizEnded => _quizEnded;
  set quizEnded(bool value) {
    _quizEnded = value;
    notifyListeners();
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int value) {
    _currentIndex = value;
    checkQuestionPosition();
    checkQuestionButtons();
    notifyListeners();
  }

  int _previousIndex = 0;
  int get previousIndex => _previousIndex;
  set previousIndex(int value) {
    _previousIndex = value;
    notifyListeners();
  }

  bool _isLastQuestion = false;
  bool get isLastQuestion => _isLastQuestion;
  set isLastQuestion(bool value) {
    _isLastQuestion = value;
    notifyListeners();
  }

  bool _isNextButtonDisabled = false;
  bool get isNextButtonDisabled => _isNextButtonDisabled;
  set isNextButtonDisabled(bool value) {
    _isNextButtonDisabled = value;
    notifyListeners();
  }

  QuizController(this._quiz);

  void startQuiz() async {
    _quizStarted = true;
    currentIndex = 0;
  }

  void navigateToNextQuestion() {
    previousIndex = currentIndex;
    if (currentIndex < quiz.questionList!.length) {
      currentIndex += 1;
    }
  }

  void navigateToPreviousQuestion() {
    previousIndex = currentIndex;
    if (currentIndex > 0) {
      currentIndex -= 1;
    }
  }

  void submitQuiz(BuildContext context) async {
    //save solved quiz to database
    await dbService.updateSolvedQuiz(quiz);
    quiz.progress = await dbService.calculateProgressForQuiz(quiz.quizId!);
    GlobalStreams.addProgressQuiz(quiz);
    notifyListeners();
    quizEnded = true;
    // Navigator.of(context).pop();
  }

  void checkQuestionPosition() {
    if (currentIndex == quiz.questionList!.length - 1) {
      isLastQuestion = true;
    } else {
      isLastQuestion = false;
    }
  }

  void checkQuestionButtons() {
    isNextButtonDisabled =
        questionAnswered(quiz.questionList![currentIndex].choiceList!);
  }

  bool questionAnswered(List<Choice> choiceList) {
    for (var choice in choiceList) {
      if (choice.isSelected) {
        return true;
      }
    }
    return false;
  }

  void confirmExitQuiz(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(
          color: Color(0xFF6738FF),
          fontSize: 18,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(); //pop dialog
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "Continue",
        style: TextStyle(
          color: Color.fromARGB(255, 224, 83, 73),
          fontSize: 18,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop(); //pop dialog
        Navigator.of(context).pop(); //pop quiz
      },
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "If you leave now, all your answers will be lost. Are you sure you want to exit?",
            style: TextStyle(fontSize: 20, height: 1.5),
          ),
        ),
        actions: [
          continueButton,
          cancelButton,
        ],
      ),
    );
  }

  void confirmSubmitQuiz(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text(
        "Cancel",
        style: TextStyle(
          color: Color.fromARGB(255, 224, 83, 73),
          fontSize: 18,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget submitButton = TextButton(
      child: const Text(
        "Submit",
        style: TextStyle(
          color: Color(0xFF6738FF),
          fontSize: 18,
        ),
      ),
      onPressed: () {
        submitQuiz(context);
        Navigator.of(context).pop();
      },
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Are you sure you want to submit your answers?",
            style: TextStyle(fontSize: 20, height: 1.5),
          ),
        ),
        actions: [
          submitButton,
          cancelButton,
        ],
      ),
    );
  }
}
