import 'package:flutter/material.dart';
import 'package:ragbot_app/Models/quiz.dart';

class QuizSolverScreen extends StatefulWidget {
  final Quiz quiz;

  QuizSolverScreen({super.key, required this.quiz});

  @override
  State<StatefulWidget> createState() => _QuizSolverScreenState();
}

class _QuizSolverScreenState extends State<QuizSolverScreen> {
  @override
  Widget build(BuildContext build) {
    return Scaffold(
        body: Text("This is the quiz solver for quiz ${widget.quiz.title}"));
  }
}
