import 'dart:async';
import 'package:ragbot_app/Models/quiz.dart';

class GlobalStreams {
  static final StreamController<Quiz> _quizStreamController =
      StreamController.broadcast();
  static Stream<Quiz> get quizStream => _quizStreamController.stream;

  static void addQuiz(Quiz quiz) {
    _quizStreamController.sink.add(quiz);
  }
}
