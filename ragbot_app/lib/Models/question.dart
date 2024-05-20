import 'package:ragbot_app/Models/choice.dart';

class Question {
  int? questionId;
  int quizId;
  String questionText;

  //at runtime
  late List<Choice>? choiceList = [];

  Question({
    this.questionId,
    required this.quizId,
    required this.questionText,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        questionId: map['questionId'] as int,
        quizId: map['quizId'] as int,
        questionText: map['questionText'] as String);
  }

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'questionText': questionText,
    };
  }

  //factory function to extract choices from list of choices contained in JSON object
  factory Question.fromJson(Map<String, dynamic> json, int quizId) {
    return Question(
      quizId: quizId,
      questionText: json['questionText'] as String,
    );
  }
}
