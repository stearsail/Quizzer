import 'package:flutter/material.dart';
import 'package:ragbot_app/Models/choice.dart';
import 'package:ragbot_app/Models/question.dart';
import 'package:ragbot_app/Models/quiz.dart';

class QuizViewer extends StatelessWidget {
  final Quiz quiz;
  const QuizViewer({super.key, required this.quiz});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF2E2E2E),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  quiz.title,
                  softWrap: true,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.exit_to_app,
                      color: Color.fromARGB(255, 224, 83, 73)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: quiz.questionList!.length,
          itemBuilder: (context, index) {
            return QuestionViewer(
                question: quiz.questionList![index], index: index);
          },
        ));
  }
}

class QuestionViewer extends StatelessWidget {
  final Question question;
  final int index;

  const QuestionViewer(
      {super.key, required this.question, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> choiceWidgets = question.choiceList!.map((choice) {
      IconData? iconData = getChoiceIcon(choice);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.5, horizontal: 0),
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 5,
              ),
              child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: choice.isCorrectChoice
                      ? const Color.fromARGB(120, 76, 175, 80)
                      : (choice.isSelected && !choice.isCorrectChoice)
                          ? const Color.fromARGB(80, 244, 67, 54)
                          : const Color.fromARGB(98, 112, 110, 110),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            choice.choiceText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 30,
                          child: Icon(
                            iconData,
                            color: iconData == Icons.highlight_off
                                ? Colors.red
                                : iconData == Icons.check_circle_outline
                                    ? Colors.green
                                    : Colors.transparent,
                            size: 27,
                          ),
                        ),
                      )
                    ],
                  )),
            )),
          ],
        ),
      );
    }).toList();
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        color: const Color(0xFF3E3E3E),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "${index + 1}. ${question.questionText}",
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Column(
              children: choiceWidgets,
            )
          ],
        ),
      ),
    ));
  }

  IconData? getChoiceIcon(Choice choice) {
    if (choice.isCorrectChoice && choice.isSelected) {
      return Icons.check_circle_outline;
    } else if (!choice.isCorrectChoice && choice.isSelected) {
      return Icons.highlight_off;
    } else {
      return null;
    }
  }
}
