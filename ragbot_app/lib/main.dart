import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/mainscreen_controller.dart';
import 'package:ragbot_app/Controllers/upload_controller.dart';
import 'package:ragbot_app/Themes/dark_theme.dart';
import 'package:ragbot_app/Views/file_uploaded_widget.dart';
import 'package:ragbot_app/Views/no_quizzes_widget.dart';
import 'package:ragbot_app/Views/processing_widget.dart';
import 'package:ragbot_app/Views/quizzes_widget.dart';
import 'package:ragbot_app/Views/upload_file_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// ignore_for_file: prefer_const_constructors
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(Duration(seconds: 5));
  FlutterNativeSplash.remove();

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
    final mainScreenController =
        Provider.of<MainScreenController>(context, listen: false);
    final uploaderViewController =
        Provider.of<UploaderViewController>(context, listen: false);
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.45;
    return Scaffold(
      backgroundColor: const Color(0xFF3E3E3E),
      appBar: AppBar(title: const Text('Main screen')),
      body: Stack(
        children: [
          Consumer<MainScreenController>(
            builder: (context, mainScreenController, child) {
              if (mainScreenController.quizzes.isEmpty) {
                return NoQuizzesWidget();
              } else {
                return QuizzesWidget(
                    mainScreenController: mainScreenController);
              }
            },
          ),
          SlidingUpPanel(
            backdropTapClosesPanel: false,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            isDraggable: false,
            parallaxEnabled: true,
            controller: uploaderViewController.panelController,
            backdropEnabled: true,
            defaultPanelState: PanelState.CLOSED,
            minHeight: 0,
            color: Color(0xFF6738FF),
            maxHeight: panelHeightOpen,
            onPanelClosed: () {
              FocusScope.of(context).unfocus();
            },
            panel: Consumer2<UploaderViewController, MainScreenController>(
                builder: (context, uploaderViewController, mainScreenController,
                    child) {
              if (!uploaderViewController.isProcessing) {
                return Center(
                    child: !uploaderViewController.fileUploaded
                        ? UploadFileWidget(
                            uploaderViewController: uploaderViewController)
                        : FileUploadedWidget(
                            uploaderViewController: uploaderViewController,
                            mainScreenController: mainScreenController));
              } else {
                return ProcessingWidget();
              }
            }),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: !mainScreenController.slideUpVisible
            ? const CircularNotchedRectangle()
            : null,
        notchMargin: 4,
      ),
      floatingActionButton: AnimatedRotation(
        turns: mainScreenController.turns,
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  !mainScreenController.slideUpVisible
                      ? uploaderViewController.panelController.open()
                      : uploaderViewController.panelController.close();
                  mainScreenController.slideUpVisible =
                      !mainScreenController.slideUpVisible;
                  mainScreenController.turns += 1 / 2;
                });
              },
              backgroundColor: !mainScreenController.slideUpVisible
                  ? Color(0xFF6738FF)
                  : Color.fromARGB(255, 224, 83, 73),
              tooltip: 'Upload a new PDF!',
              child: !mainScreenController.slideUpVisible
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
