import 'package:ragbot_app/Models/question.dart';

class Quiz {
  int? quizId;
  String title;
  String sourceFile;

  //at runtime
  late String progress;
  late List<Question>? questionList;

  Quiz({
    this.quizId,
    required this.title,
    required this.sourceFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'sourceFile': sourceFile,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      quizId: map['quizId'] as int,
      title: map['title'] as String,
      sourceFile: map['sourceFile'] as String,
    );
  }
}
