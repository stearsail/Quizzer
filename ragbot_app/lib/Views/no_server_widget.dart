import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoServerConnectionWidget extends StatelessWidget {
  const NoServerConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    "assets/maintenance.json",
                  )),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                "Quizzer servers are currently under maintenance. Please try again later!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ]),
    );
  }
}
