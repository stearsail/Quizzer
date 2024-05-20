import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/quiz_controller.dart';
import 'package:ragbot_app/Models/question.dart';

class QuizQuestionWidget extends StatefulWidget {
  final List<Question> questions;

  const QuizQuestionWidget({super.key, required this.questions});

  @override
  State<StatefulWidget> createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<QuizQuestionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final quizController = Provider.of<QuizController>(context);
    final questionNr = quizController.currentIndex;
    final previousQuestionNr = quizController.previousIndex;
    final question = widget.questions[questionNr];
    List<Widget> choiceWidgets = [];
    for (var choice in question.choiceList!) {
      choiceWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Checkbox(
                value: choice.isSelected,
                onChanged: (bool? value) {
                    quizController.checkQuestionButtons();
                },
                fillColor: MaterialStateProperty.all(Colors.grey),
              ),
              Flexible(
                  child: Text(
                choice.choiceText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ))
            ],
          ),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            bool isNavigatingForward = questionNr > previousQuestionNr;

            var inAnimation = Tween<Offset>(
              begin: isNavigatingForward
                  ? const Offset(1.0, 0.0)
                  : const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation);

            var outAnimation = Tween<Offset>(
              begin: isNavigatingForward
                  ? const Offset(-1.0, 0.0)
                  : const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation);

            if (child.key == ValueKey(questionNr)) {
              return SlideTransition(
                position: inAnimation,
                child: child,
              );
            } else {
              return SlideTransition(
                position: outAnimation,
                child: child,
              );
            }
          },
          child: Column(
            key: ValueKey<int>(questionNr),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${questionNr + 1}. ${question.questionText}",
                style: const TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 50),
                child: Column(
                  children: choiceWidgets,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
