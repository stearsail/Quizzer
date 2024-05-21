import 'package:flutter/material.dart';
import 'package:ragbot_app/Models/question.dart';

class Quiz {
  int? quizId;
  String title;
  String sourceFile;

  //at runtime
  late List<Question>? questionList;

  Color _progressColor = Colors.white;
  Color get progressColor => _progressColor;

  late String _progress;
  String get progress => _progress;
  set progress(String value) {
    _progress = value;
    _progressColor = getColorFromScore(value);
  }

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

  Color getColorFromScore(String scoreStr) {
    RegExp regExp = RegExp(r'(\d+)%');
    Match? match = regExp.firstMatch(scoreStr);
    if (match != null) {
      int score = int.parse(match.group(
          1)!); // Extracts the number before the '%' and converts it to int

      if (score >= 80) {
        return const Color.fromARGB(255, 17, 73, 19); // High score
      } else if (score >= 50) {
        return const Color.fromARGB(255, 240, 171, 67); // Average score
      } else {
        return const Color.fromARGB(255, 224, 99, 99); // Low score
      }
    }
    return Colors.white;
  }
}
