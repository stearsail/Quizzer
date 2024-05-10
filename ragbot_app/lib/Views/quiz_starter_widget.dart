import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/quiz_controller.dart';
import 'package:ragbot_app/Models/question.dart';
import 'package:ragbot_app/Services/database_service.dart';

class QuizStarterWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuizStarterWidgetState();
}

class _QuizStarterWidgetState extends State<QuizStarterWidget> {
  late Future<List<Question>> _getQuestions;

  @override
  void initState() {
    super.initState();
    final quizController = Provider.of<QuizController>(context, listen: false);
    _getQuestions = quizController.loadQuestions();
  }

  @override
  Widget build(BuildContext build) {
    final quizController = Provider.of<QuizController>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(quizController.quiz.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                  textAlign: TextAlign.center),
              Text("Source: ${quizController.quiz.sourceFile}",
                  style: const TextStyle(color: Colors.white, fontSize: 25)),
              FutureBuilder(
                  future: _getQuestions,
                  builder: (context, AsyncSnapshot<List<Question>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Questions: 0",
                          style: TextStyle(color: Colors.white, fontSize: 25));
                    } else {
                      return Text("Questions: ${snapshot.data!.length}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25));
                    }
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SizedBox(
                        height: 70,
                        child: FittedBox(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF5DC461)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: quizController.questionsLoaded
                                ? () => quizController.startQuiz()
                                : null,
                            child: const Text(
                              "Begin",
                              style: TextStyle(color: Color(0xFFF3F6F4)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        height: 70,
                        child: FittedBox(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 224, 83, 73),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              navigateBack(context);
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Color(0xFFF3F6F4)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
