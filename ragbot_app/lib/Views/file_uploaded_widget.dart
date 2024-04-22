import 'package:flutter/material.dart';
import 'package:ragbot_app/Controllers/mainscreen_controller.dart';
import 'package:ragbot_app/Controllers/upload_controller.dart';

class FileUploadedWidget extends StatefulWidget {
  final UploaderViewController uploaderViewController;
  final MainScreenController mainScreenController;

  const FileUploadedWidget(
      {super.key,
      required this.uploaderViewController,
      required this.mainScreenController});

  @override
  State<StatefulWidget> createState() => _FileUploadedWidgetState();
}

class _FileUploadedWidgetState extends State<FileUploadedWidget> {
  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 120,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                child: RichText(
                  text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                      text: "Your quiz:\n",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "${widget.uploaderViewController.quizTitle}\n",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 250, 194, 72),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text:
                          "has been succesfully created!\nWould you like to take it now or later?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
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
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF5DC461)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: null,
                      child: const Text(
                        "Take now",
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
                            const Color.fromARGB(255, 224, 83, 73),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            widget.mainScreenController.turns += 0.5;
                            widget.mainScreenController.slideUpVisible =
                                !widget.mainScreenController.slideUpVisible;

                            widget.uploaderViewController.panelController
                                .close();
                            widget.uploaderViewController.resetController();
                          });
                        },
                        child: const Text(
                          "Take later",
                          style: TextStyle(color: Color(0xFFF3F6F4)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]);
  }
}
