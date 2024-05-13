import 'dart:async';
import 'package:ragbot_app/Models/quiz.dart';

class GlobalStreams {
  static final StreamController<Quiz> _quizStreamController =
      StreamController.broadcast();
  static Stream<Quiz> get quizStream => _quizStreamController.stream;

  static final StreamController<Quiz> _progressStreamController = 
      StreamController.broadcast();
  static Stream<Quiz> get progressStream => _progressStreamController.stream;

  static final StreamController<Quiz> _deletedQuizStreamController =
      StreamController.broadcast();
    static Stream<Quiz> get deletedQuizStream => _deletedQuizStreamController.stream;

  static void addQuiz(Quiz quiz) {
    _quizStreamController.sink.add(quiz);
  }

  static void addProgressQuiz(Quiz quiz){
    _progressStreamController.sink.add(quiz);
  }

  static void deleteQuiz(Quiz quiz){
    _deletedQuizStreamController.sink.add(quiz);
  }
}
