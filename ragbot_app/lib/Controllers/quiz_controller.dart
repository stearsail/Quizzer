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
}
