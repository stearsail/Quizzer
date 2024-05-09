import 'package:flutter/material.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Services/database_service.dart';

class QuizSolverScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizSolverScreen({super.key, required this.quiz});

  @override
  State<StatefulWidget> createState() => _QuizSolverScreenState();
}

class _QuizSolverScreenState extends State<QuizSolverScreen> {
  late Future<List<Question>> _questionsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future in initState to load questions only once
    _questionsFuture =
        DatabaseService().getQuestionsForQuiz(widget.quiz.quizId!);
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
        body: FutureBuilder<List<Question>>(
      future: _questionsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var quizQuestions = snapshot.data!;
        return Center(
            child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.quiz.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                          ),
                          textAlign: TextAlign.center),
                      Text("Source: ${widget.quiz.sourceFile}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25)),
                      Text("Questions: ${quizQuestions.length}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25)),
                    ])));
      },
    ));
  }
}
