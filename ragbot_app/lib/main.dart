import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/mainscreen_controller.dart';
import 'package:ragbot_app/Controllers/upload_controller.dart';
import 'package:ragbot_app/Themes/dark_theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:lottie/lottie.dart';

// ignore_for_file: prefer_const_constructors
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<MainScreenController>(
              create: (context) => MainScreenController()),
          ChangeNotifierProvider<UploaderViewController>(
              create: (context) => UploaderViewController())
        ],
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late PanelController panelController = PanelController();

  bool slideUpVisible = false; //variables that involve animations
  double turns = 0.0;
  final panelAnimationDuration = const Duration(milliseconds: 300);

  @override
  initState() {
    super.initState();
    final mainScreenController = Provider.of<MainScreenController>(context,
        listen: false); //loading list animation
    mainScreenController.loadList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.45;
    return Scaffold(
      backgroundColor: const Color(0xFF3E3E3E),
      appBar: AppBar(title: const Text('Main screen')),
      body: Stack(
        children: [
          Consumer<MainScreenController>(
            builder: (context, mainScreenController, child) {
              if (mainScreenController.quizzes.isEmpty) {
                return Center(
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      SvgPicture.asset(
                        "assets/happy_cat.svg",
                        height: 300,
                        colorFilter:
                            ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      ),
                      Text(
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
              return SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: AnimatedList(
                  key: mainScreenController.listKey,
                  initialItemCount: mainScreenController.quizzes.length,
                  itemBuilder: (context, index, animation) {
                    final quiz = mainScreenController.quizzes[index];
                    return SlideTransition(
                      position: CurvedAnimation(
                        curve: Curves.easeOut,
                        parent: animation,
                      ).drive(((Tween<Offset>(
                        begin: Offset(1, 0),
                        end: Offset(0, 0),
                      )))),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const StretchMotion(),
                          dragDismissible: true,
                          children: [
                            SlidableAction(
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
                              backgroundColor: Color.fromARGB(255, 255, 54, 54),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(quiz.title,
                              style: const TextStyle(
                                  fontSize: 20, color: Color(0xFFF3F6F4))),
                          subtitle: Text(
                            'Score: 70%',
                            style: const TextStyle(color: Color(0xFFF3F6F4)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SlidingUpPanel(
            backdropTapClosesPanel: false,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            isDraggable: false,
            parallaxEnabled: true,
            controller: panelController,
            backdropEnabled: true,
            defaultPanelState: PanelState.CLOSED,
            minHeight: 0,
            color: Color(0xFF6738FF),
            maxHeight: panelHeightOpen,
            onPanelClosed: () {
              FocusScope.of(context).unfocus();
            },
            panel: Consumer<UploaderViewController>(
                builder: (context, uploaderViewController, child) {
              if (!uploaderViewController.isProcessing) {
                return Center(
                  child: !uploaderViewController.fileUploaded
                      ? Flex(
                          mainAxisAlignment: MainAxisAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            SizedBox(
                              width: 350,
                              height: 100,
                              child: TextField(
                                cursorColor: Color(0xFF6738FF),
                                controller:
                                    uploaderViewController.titleInputController,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    errorText:
                                        uploaderViewController.textErrorMessage,
                                    errorStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 255, 238, 90)),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 250, 194, 72),
                                        width: 2.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 250, 194, 72),
                                          width: 2.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: "A title for your new test",
                                    prefixIcon: Icon(Icons.short_text),
                                    filled: true,
                                    fillColor: Color(0xFFF3F6F4),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: SizedBox(
                                height: 85,
                                child: FittedBox(
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.disabled)) {
                                            return Colors.grey;
                                          }
                                          return Color(0xFF5DC461);
                                        }),
                                        shadowColor: MaterialStatePropertyAll(
                                            Color.fromARGB(255, 43, 90, 53)),
                                        elevation: MaterialStatePropertyAll(5)),
                                    onPressed: uploaderViewController
                                                .isButtonEnabled ==
                                            true
                                        ? () =>
                                            uploaderViewController.uploadFile()
                                        : null,
                                    label: const Text("Upload file"),
                                    icon: const Icon(Icons.upload),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 30),
                              child: Text(
                                "Set a title and upload a PDF file to begin processing and generate your quiz!",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      : Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 120,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 20, left: 30, right: 30),
                                    child: RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: "Your quiz:\n",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "${uploaderViewController.quizTitle}\n",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 250, 194, 72),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
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
                                padding: EdgeInsets.only(top: 30),
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
                                                MaterialStateProperty.all<
                                                    Color>(Color(0xFF5DC461)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          onPressed: null,
                                          child: const Text(
                                            "Take now",
                                            style: TextStyle(
                                                color: Color(0xFFF3F6F4)),
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
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color.fromARGB(255, 224, 83, 73),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          onPressed: () =>
                                              uploaderViewController
                                                  .resetController(),
                                          child: const Text(
                                            "Take later",
                                            style: TextStyle(
                                                color: Color(0xFFF3F6F4)),
                                          ),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                );
              } else {
                return Center(
                    child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.asset("assets/processing_file.json")),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        "The PDF is being processed, this may take a while depending on how large the file is...",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ));
              }
            }),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: !slideUpVisible ? const CircularNotchedRectangle() : null,
        notchMargin: 4,
      ),
      floatingActionButton: AnimatedRotation(
        turns: turns,
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  !slideUpVisible
                      ? panelController.open()
                      : panelController.close();
                  slideUpVisible = !slideUpVisible;
                  turns += 1 / 2;
                });
              },
              backgroundColor: !slideUpVisible
                  ? Color(0xFF6738FF)
                  : Color.fromARGB(255, 224, 83, 73),
              tooltip: 'Upload a new PDF!',
              child: !slideUpVisible
                  ? Icon(
                      Icons.upload,
                      size: 28,
                    )
                  : Icon(Icons.arrow_upward, size: 28),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

void _confirmDeleteQuiz(
    BuildContext context, String title, int quizId, int index) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Are you sure you want to delete the quiz:\n$title?",
            style: TextStyle(fontSize: 18, height: 1.5),
          )),
      actions: [
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Color(0xFF6738FF),
              fontSize: 18,
            ),
          ),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
        TextButton(
          child: Text(
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
