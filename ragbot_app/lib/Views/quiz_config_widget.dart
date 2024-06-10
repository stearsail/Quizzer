import 'package:flutter/material.dart';
import 'package:ragbot_app/Controllers/mainscreen_controller.dart';
import 'package:ragbot_app/Controllers/upload_controller.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Views/processing_widget.dart';

class QuizConfigWidget extends StatefulWidget {
  final UploaderViewController uploaderViewController;
  final MainScreenController mainScreenController;
  final Function(BuildContext, Quiz) navigateToQuizScreen;
  const QuizConfigWidget(
      {super.key,
      required this.uploaderViewController,
      required this.mainScreenController,
      required this.navigateToQuizScreen});

  @override
  State<StatefulWidget> createState() => _QuizConfigWidgetState();
}

class _QuizConfigWidgetState extends State<QuizConfigWidget> {
  late int questionsAvailable;
  int selectedValue = 10;

  List<ButtonSegment<int>> getQuestionSegments() {
    List<ButtonSegment<int>> segments = [];
    questionsAvailable = widget.uploaderViewController.availableTexts;
    // Always available
    segments.add(const ButtonSegment<int>(
      value: 10,
      label: Text(
        '10',
        style: TextStyle(fontSize: 20),
      ),
      enabled: true,
    ));

    // Conditionally available

    segments.add(ButtonSegment<int>(
      value: 20,
      label: const Text(
        '20',
        style: TextStyle(fontSize: 20),
      ),
      enabled: widget.uploaderViewController.availableTexts >= 30,
    ));

    // Conditionally available
    segments.add(ButtonSegment<int>(
      value: 30,
      label: const Text(
        '30',
        style: TextStyle(fontSize: 20),
      ),
      enabled: widget.uploaderViewController.availableTexts >= 50,
    ));

    return segments;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.uploaderViewController.isProcessing) {
      if (!widget.uploaderViewController.quizConfigured) {
        return Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 48,
              child: SegmentedButton<int>(
                selectedIcon: const Icon(
                  Icons.check,
                  size: 22,
                ),
                segments: getQuestionSegments(),
                selected: <int>{
                  widget.uploaderViewController.selectedNrQuestions
                },
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  selectedForegroundColor: Colors.white,
                  selectedBackgroundColor: Colors.green,
                  disabledForegroundColor:
                      const Color.fromARGB(115, 255, 255, 255),
                  disabledBackgroundColor: Colors.transparent,
                ),
                onSelectionChanged: (Set<int> newSelection) {
                  selectedValue = newSelection.first;
                  widget.uploaderViewController.selectedNrQuestions =
                      newSelection.first;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Text(
                'Select a number of questions for your new quiz! The available options are based on the size of the document you provided.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: SizedBox(
                height: 55,
                child: FittedBox(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }
                          return Colors.green;
                        }),
                        shadowColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 43, 90, 53)),
                        elevation: const MaterialStatePropertyAll(5)),
                    onPressed: () =>
                        widget.uploaderViewController.generateQuiz(),
                    label: const Text(
                      "Generate",
                      style: TextStyle(fontSize: 18),
                    ),
                    icon: const Icon(
                      Icons.settings,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
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
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
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
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF5DC461)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            widget.navigateToQuizScreen(context,
                                widget.uploaderViewController.generatedQuiz!);
                            hideSlideUpPanel();
                          },
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
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              hideSlideUpPanel();
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
    } else {
      return const ProcessingWidget();
    }
  }

  void hideSlideUpPanel() {
    setState(() {
      widget.mainScreenController.turns += 0.5;
      widget.mainScreenController.slideUpVisible =
          !widget.mainScreenController.slideUpVisible;

      widget.uploaderViewController.panelController.close();
      widget.uploaderViewController.resetController();
    });
  }
}
