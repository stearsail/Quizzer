import 'package:flutter/material.dart';
import 'package:ragbot_app/Models/choice.dart';
import 'package:ragbot_app/Models/question.dart';

class QuizQuestionWidget extends StatefulWidget {
  final List<Question> questions;
  final int questionNr;
  final Function() navigateToNextQuestion;
  final Function() navigateToPreviousQuestion;
  final Function() submitQuiz;
  const QuizQuestionWidget(
      {super.key,
      required this.questions,
      required this.questionNr,
      required this.navigateToNextQuestion,
      required this.navigateToPreviousQuestion,
      required this.submitQuiz});

  @override
  State<StatefulWidget> createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<QuizQuestionWidget> {
  late int questionNr = widget.questionNr;
  late Question question = widget.questions[questionNr - 1];
  bool _isNextButtonDisabled = true;
  bool _isLastQuestion = false;

  @override
  void initState() {
    super.initState();
    _isLastQuestion = questionNr == widget.questions.length;
    _isNextButtonDisabled = questionAnswered(question.choiceList);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> choiceWidgets = [];
    for (var choice in question.choiceList) {
      choiceWidgets.add(Row(
        children: [
          Checkbox(
            value: choice.isSelected,
            onChanged: (bool? value) {
              setState(() {
                choice.isSelected = !choice.isSelected;
                if (choice.isSelected) {
                  //if its been set to true, set all other to false
                  for (var otherChoice in question.choiceList) {
                    if (otherChoice != choice) {
                      otherChoice.isSelected = false;
                    }
                  }
                }
                _isNextButtonDisabled = questionAnswered(question.choiceList);
              });
            },
            fillColor: MaterialStateProperty.all(Colors.grey),
          ),
          Text(
            choice.choiceText,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          )
        ],
      ));
    }
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$questionNr. ${question.questionText}",
                style: const TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 50),
                child: Column(
                  children: choiceWidgets,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: questionNr == 1
                          ? null
                          : widget.navigateToPreviousQuestion,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6738FF),
                          disabledBackgroundColor: const Color(0x0FFFFFFF)),
                      child: const Icon(Icons.arrow_back)),
                  ElevatedButton(
                    onPressed: _isNextButtonDisabled
                        ? (_isLastQuestion
                            ? widget.submitQuiz
                            : widget.navigateToNextQuestion)
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6738FF),
                        disabledBackgroundColor: const Color(0x0FFFFFFF)),
                    child: _isLastQuestion
                        ? const Text("Submit")
                        : const Icon(Icons.arrow_forward),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

bool questionAnswered(List<Choice> choiceList) {
  for (var choice in choiceList) {
    if (choice.isSelected) {
      return true;
    }
  }

  return false;
}
