import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/mainscreen_controller.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Views/no_quizzes_widget.dart';

class QuizzesWidget extends StatefulWidget {
  final MainScreenController mainScreenController;
  final Function(BuildContext, Quiz) navigateToQuizScreen;

  const QuizzesWidget(
      {super.key,
      required this.mainScreenController,
      required this.navigateToQuizScreen});

  @override
  State<StatefulWidget> createState() => _QuizzesWidgetState();
}

class _QuizzesWidgetState extends State<QuizzesWidget> {
  @override
  void initState() {
    super.initState();
    final mainScreenController = Provider.of<MainScreenController>(context,
        listen: false); //loading list animation
    mainScreenController.loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenController>(
      builder: (context, mainScreenController, child) {
        if (mainScreenController.listEmpty) {
          return const NoQuizzesWidget();
        } else {
          return SlidableAutoCloseBehavior(
            closeWhenOpened: true,
            child: AnimatedList(
              key: widget.mainScreenController.listKey,
              initialItemCount: widget.mainScreenController.quizzes.length,
              itemBuilder: (context, index, animation) {
                final quiz = widget.mainScreenController.quizzes[index];
                return SlideTransition(
                  position: CurvedAnimation(
                    curve: Curves.easeOut,
                    parent: animation,
                  ).drive(((Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: const Offset(0, 0),
                  )))),
                  child: Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.6,
                      motion: const StretchMotion(),
                      dragDismissible: true,
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              widget.navigateToQuizScreen(context, quiz),
                          icon: Icons.edit_square,
                          label: 'Solve',
                          backgroundColor: Colors.blue,
                        ),
                        const SlidableAction(
                          onPressed: null,
                          icon: Icons.visibility,
                          label: 'View',
                          backgroundColor: Color(0xFF6738FF),
                        ),
                        SlidableAction(
                          onPressed: (_) => _confirmDeleteQuiz(
                              context, quiz.title, quiz.quizId!, index),
                          icon: Icons.delete_forever_sharp,
                          label: 'Delete',
                          backgroundColor:
                              const Color.fromARGB(255, 255, 54, 54),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(quiz.title,
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xFFF3F6F4))),
                      subtitle: Text(
                        quiz.progress!,
                        style:
                            TextStyle(color: getColorFromScore(quiz.progress!)),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

Color getColorFromScore(String scoreStr) {
  RegExp regExp = RegExp(r'(\d+)%');
  Match? match = regExp.firstMatch(scoreStr);
  if (match != null) {
    int score = int.parse(match.group(
        1)!); // Extracts the number before the '%' and converts it to int

    if (score >= 80) {
      return const Color.fromARGB(255, 115, 201, 118); // High score
    } else if (score >= 50) {
      return const Color.fromARGB(255, 240, 171, 67); // Average score
    } else {
      return const Color.fromARGB(255, 224, 99, 99); // Low score
    }
  }
  return Colors.white;
}

void _confirmDeleteQuiz(
    BuildContext context, String title, int quizId, int index) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Are you sure you want to delete the quiz:\n$title?",
            style: const TextStyle(fontSize: 18, height: 1.5),
          )),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF6738FF),
              fontSize: 18,
            ),
          ),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
        TextButton(
          child: const Text(
            'Delete',
            style: TextStyle(
              color: Color.fromARGB(255, 224, 83, 73),
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Provider.of<MainScreenController>(context, listen: false)
                .deleteQuiz(quizId, index);
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
