import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/mainscreen_controller.dart';
import 'package:ragbot_app/Controllers/quiz_controller.dart';
import 'package:ragbot_app/Controllers/upload_controller.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Services/connectivity_service.dart';
import 'package:ragbot_app/Themes/dark_theme.dart';
import 'package:ragbot_app/Views/analyzing_widget.dart';
import 'package:ragbot_app/Views/no_internet_screen.dart';
import 'package:ragbot_app/Views/quiz_config_widget.dart';
import 'package:ragbot_app/Views/quiz_screen.dart';
import 'package:ragbot_app/Views/quizzes_widget.dart';
import 'package:ragbot_app/Views/upload_file_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// ignore_for_file: prefer_const_constructors

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  FlutterNativeSplash.remove();
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
  Widget build(BuildContext context) {
    final mainScreenController =
        Provider.of<MainScreenController>(context, listen: false);
    final uploaderViewController =
        Provider.of<UploaderViewController>(context, listen: false);
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.45;
    return Scaffold(
      backgroundColor: const Color(0xFF3E3E3E),
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Quizzer'),
          SizedBox(height: 80, child: Image.asset('assets/cat_logo_1152.png'))
        ],
      )),
      body: Stack(
        children: [
          Consumer<MainScreenController>(
            builder: (context, mainScreenController, child) {
              return QuizzesWidget(
                mainScreenController: mainScreenController,
                navigateToQuizScreen: navigateToQuizScreen,
              );
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
              panel: StreamBuilder<InternetStatus>(
                  stream: ConnectivityService().connectionChange,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data == InternetStatus.connected) {
                        return Consumer2<UploaderViewController,
                                MainScreenController>(
                            builder: (context, uploaderViewController,
                                mainScreenController, child) {
                          if (!uploaderViewController.isAnalyzing) {
                            return Center(
                                child: !uploaderViewController.fileUploaded
                                    ? UploadFileWidget(
                                        uploaderViewController:
                                            uploaderViewController)
                                    : QuizConfigWidget(
                                        uploaderViewController:
                                            uploaderViewController,
                                        mainScreenController:
                                            mainScreenController,
                                        navigateToQuizScreen:
                                            navigateToQuizScreen,
                                      ));
                          } else {
                            return AnalyzingWidget();
                          }
                        });
                      } else {
                        return NoInternetWidget();
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }))
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
                if (!mainScreenController.slideUpVisible) {
                  uploaderViewController.getServerStatus();
                }
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

  void navigateToQuizScreen(BuildContext context, Quiz quiz) {
    Navigator.of(context).push(
      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
        QuizController controller = QuizController(quiz);
        return ChangeNotifierProvider<QuizController>.value(
          value: controller,
          child: QuizScreen(),
        );
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
