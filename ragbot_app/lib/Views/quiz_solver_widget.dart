import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/quiz_controller.dart';
import 'package:ragbot_app/Models/question.dart';
import 'package:ragbot_app/Views/quiz_question_widget.dart';

class QuizSolverWidget extends StatefulWidget {
  final List<Question> questions;
  const QuizSolverWidget({super.key, required this.questions});

  @override
  State<StatefulWidget> createState() => _QuizSolverWidgetState();
}

class _QuizSolverWidgetState extends State<QuizSolverWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    int i = 0;
    var quizController = Provider.of<QuizController>(context, listen: false);
    return Scaffold(
        body: Stack(children: [
      Positioned(
        right: 30,
        top: 60,
        child: IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              quizController.showClosingQuizDialog(context);
            }),
      ),
      QuizQuestionWidget(
        questions: widget.questions,
        questionNr: i + 1,
        navigateToNextQuestion: quizController.navigateToNextQuestion,
        navigateToPreviousQuestion: quizController.navigateToPreviousQuestion,
        submitQuiz: quizController.submitQuiz,
      ),
    ]));
  }
}



