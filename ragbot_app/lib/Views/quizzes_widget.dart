import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/mainscreen_controller.dart';

class QuizzesWidget extends StatefulWidget {
  final MainScreenController mainScreenController;

  const QuizzesWidget({super.key, required this.mainScreenController});
  
  @override
  State<StatefulWidget> createState() => _QuizzesWidgetState();
}

class _QuizzesWidgetState extends State<QuizzesWidget> {
  @override
  Widget build(BuildContext context) {
    
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
                motion: const StretchMotion(),
                dragDismissible: true,
                children: [
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
                    backgroundColor: const Color.fromARGB(255, 255, 54, 54),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(quiz.title,
                    style: const TextStyle(
                        fontSize: 20, color: Color(0xFFF3F6F4))),
                subtitle: const Text(
                  'Score: 70%',
                  style: TextStyle(color: Color(0xFFF3F6F4)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
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