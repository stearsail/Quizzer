import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ragbot_app/Models/choice.dart';
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
      currentIndex = 0;
      notifyListeners();
    }
  }

  void navigateToNextQuestion() {
    previousIndex = currentIndex;
    if (currentIndex < questions.length) {
      currentIndex += 1;
      notifyListeners();
    }
  }

  void navigateToPreviousQuestion() {
    previousIndex = currentIndex;
    if (currentIndex > 0) {
      currentIndex -= 1;
      notifyListeners();
    }
  }

  void submitQuiz() {}

  void checkQuestionPosition() {
    if (currentIndex == questions.length - 1) {
      isLastQuestion = true;
    } else {
      isLastQuestion = false;
    }
  }

  void checkQuestionButtons() {
    isNextButtonDisabled = questionAnswered(questions[currentIndex].choiceList);
  }

  bool questionAnswered(List<Choice> choiceList) {
    for (var choice in choiceList) {
      if (choice.isSelected) {
        return true;
      }
    }

    return false;
  }
}
