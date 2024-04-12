import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/mainscreen_controller.dart';
import 'package:ragbot_app/Themes/dark_theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
        home: ChangeNotifierProvider(
            create: (context) => MainScreenController(), child: MainScreen()));
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
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.4;
    return Scaffold(
      backgroundColor: const Color(0xFF3E3E3E),
      appBar: AppBar(title: const Text('Main screen')),
      body: Stack(
        children: [
          Consumer<MainScreenController>(
            builder: (context, mainScreenController, child) {
              if (mainScreenController.tests.isEmpty) {
                return const Center(
                    child: Text(
                        'Looks like you have no previous tests\nUpload a PDF to get started!'));
              }
              return SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  child: AnimatedList(
                    key: mainScreenController.listKey,
                    initialItemCount: mainScreenController.tests.length,
                    itemBuilder: (context, index, animation) {
                      final test = mainScreenController.tests[index];
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
                              children: const [
                                SlidableAction(
                                  onPressed: null,
                                  icon: Icons.visibility,
                                  label: 'View',
                                  backgroundColor: Color(0xFF6738FF),
                                ),
                                SlidableAction(
                                  onPressed: null,
                                  icon: Icons.delete_forever_sharp,
                                  label: 'Delete',
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 54, 54),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(test,
                                  style: const TextStyle(
                                      fontSize: 20, color: Color(0xFFF3F6F4))),
                              subtitle: Text(
                                'Score: 70%',
                                style:
                                    const TextStyle(color: Color(0xFFF3F6F4)),
                              ),
                            ),
                          ));
                    },
                  ));
            },
          ),
          SlidingUpPanel(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            isDraggable: false,
            parallaxEnabled: true,
            controller: panelController,
            color: Color(0xFF6738FF),
            defaultPanelState: PanelState.CLOSED,
            minHeight: 0,
            maxHeight: panelHeightOpen,
            panel: Container(
              height: 400,
              width: 400,
              child: SizedBox(
                height: 100,
                child: FittedBox(
                  child: ElevatedButton.icon(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFF6738FF))),
                    onPressed: () => null,
                    label: const Text("Upload file"),
                    icon: const Icon(Icons.upload),
                  ),
                ),
              ),
            ),
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
