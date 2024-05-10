import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/quiz_controller.dart';
import 'package:ragbot_app/Views/quiz_solver_widget.dart';
import 'package:ragbot_app/Views/quiz_starter_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Consumer<QuizController>(
      builder: (context, quizController, child) {
        if (!quizController.quizStarted) {
          return QuizStarterWidget();
        } else {
          return QuizSolverWidget();
        }
      },
    );
  }
}
