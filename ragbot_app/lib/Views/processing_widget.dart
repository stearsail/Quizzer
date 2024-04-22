import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProcessingWidget extends StatelessWidget {
  const ProcessingWidget({super.key});
  
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
              child: Lottie.asset("assets/processing_file.json")),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            "The PDF is being processed, this may take a while depending on how large the file is...",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ));
  }
}