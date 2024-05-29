import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/quiz_controller.dart';
import 'package:ragbot_app/Models/question.dart';
import 'package:ragbot_app/Views/quiz_question_widget.dart';
import 'package:ragbot_app/Views/quiz_result_widget.dart';

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
    return Consumer<QuizController>(builder: (context, quizController, child) {
      if (!quizController.quizEnded) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                right: 30,
                top: 60,
                child: IconButton(
                    iconSize: 35,
                    icon: const Icon(Icons.exit_to_app,
                        color: Color.fromARGB(255, 224, 83, 73)),
                    onPressed: () {
                      quizController.confirmExitQuiz(context);
                    }),
              ),
              QuizQuestionWidget(questions: quizController.quiz.questionList!),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35, bottom: 75),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: navigationButtons(
                      quizController,
                      quizController.isLastQuestion,
                      quizController.isNextButtonDisabled),
                ),
              )
            ],
          ),
        );
      } else {
        return QuizResultWidget(quiz: quizController.quiz);
      }
    });
  }

  Widget navigationButtons(QuizController quizController, bool isLastQuestion,
      bool isNextButtonDisabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 50,
          width: 100,
          child: ElevatedButton(
              onPressed: quizController.currentIndex == 0
                  ? null
                  : quizController.navigateToPreviousQuestion,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6738FF),
                  disabledBackgroundColor: const Color(0x0FFFFFFF)),
              child: const Icon(
                Icons.arrow_back,
                size: 27,
              )),
        ),
        SizedBox(
          height: 50,
          width: 100,
          child: ElevatedButton(
            onPressed: isNextButtonDisabled
                ? (isLastQuestion
                    ? () => quizController.confirmSubmitQuiz(context)
                    : quizController.navigateToNextQuestion)
                : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6738FF),
                disabledBackgroundColor: const Color(0x0FFFFFFF)),
            child: isLastQuestion
                ? const Text("Submit")
                : const Icon(
                    Icons.arrow_forward,
                    size: 27,
                  ),
          ),
        ),
      ],
    );
  }
}
