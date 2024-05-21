import 'package:flutter/material.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Views/quiz_viewer.dart';

class QuizResultWidget extends StatelessWidget {
  final Quiz quiz;

  const QuizResultWidget({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    var progress = quiz.progress.split(' - ');
    return Scaffold(
      backgroundColor: quiz.progressColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: 300,
                child: getImageFromScore(quiz.progress),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, right: 20, left: 20),
              child: Text(
                getResultTextFromScore(quiz.progress),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Text(
              progress[0],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
            Text(
              progress[1],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
            resultWidgetButtons(context),
          ],
        ),
      ),
    );
  }

  Widget resultWidgetButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      navigateToResultScreen(context, quiz);
                    },
                    child: const Text(
                      "Review quiz",
                      style: TextStyle(color: Color(0xFFF3F6F4)),
                    ),
                  )),
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
                          const Color(0xFF6738FF),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Finish",
                        style: TextStyle(color: Color(0xFFF3F6F4)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Image getImageFromScore(String scoreStr) {
    RegExp regExp = RegExp(r'(\d+)%');
    Match? match = regExp.firstMatch(scoreStr);
    if (match != null) {
      int score = int.parse(match.group(
          1)!); // Extracts the number before the '%' and converts it to int

      if (score >= 80) {
        return Image.asset("assets/good_results.png"); // High score
      } else if (score >= 50) {
        return Image.asset("assets/ok_results.png"); // Average score
      } else {
        return Image.asset("assets/bad_results.png"); // Low score
      }
    }
    return Image.asset("assets/ok_results.png");
  }

  String getResultTextFromScore(String scoreStr) {
    RegExp regExp = RegExp(r'(\d+)%');
    Match? match = regExp.firstMatch(scoreStr);
    if (match != null) {
      int score = int.parse(match.group(
          1)!); // Extracts the number before the '%' and converts it to int

      if (score >= 80) {
        return "Fantastic work! You've scored 80% or higher on your test. Your dedication and hard work are clearly paying off. Keep up the great momentum as you continue to master the material!"; // High score
      } else if (score >= 50) {
        return "Good effort! You've scored between 50% and 80% on your test. You're making solid progress, but there's room for improvement!"; // Average score
      } else {
        return "Looks like this was a tough test for you. Don't get discouraged — challenges are just opportunities in disguise. You can definitely improve with practice!"; // Low score
      }
    }
    return "Placeholder";
  }

  void navigateToResultScreen(BuildContext context, Quiz quiz) {
    Navigator.of(context).push(
      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
        return QuizViewer(quiz: quiz);
      }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      }),
    );
  }
}
