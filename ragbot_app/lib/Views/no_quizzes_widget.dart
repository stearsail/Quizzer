import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoQuizzesWidget extends StatelessWidget {
  const NoQuizzesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        direction: Axis.vertical,
        children: [
          SvgPicture.asset(
            "assets/happy_cat.svg",
            height: 300,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          const Text(
            'Looks like you have no previous quizzes\nUpload a PDF to get started!',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
