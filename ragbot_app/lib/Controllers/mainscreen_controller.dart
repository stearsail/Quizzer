import 'package:flutter/material.dart';
import 'package:ragbot_app/Controllers/stream_controller.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Services/database_service.dart';

class MainScreenController extends ChangeNotifier {
  final DatabaseService dbService = DatabaseService();
  final List<Quiz> _quizzes = [];
  bool slideUpVisible = false; //variables that involve animations
  double turns = 0.0;
  bool listEmpty = false;
  final panelAnimationDuration = const Duration(milliseconds: 300);

  List<Quiz> get quizzes => _quizzes;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  MainScreenController() {
    GlobalStreams.quizStream.listen((quiz) {
      addQuiz(quiz);
    });
    GlobalStreams.progressStream.listen((quiz) {
      updateQuizProgress(quiz);
    });
  }

  Future<void> loadList() async {
    final listToAdd = await dbService.getAllQuizzes();
    listEmpty = listToAdd!.isEmpty;
    notifyListeners();

    for (var i = 0; i < listToAdd.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500), () {
        _quizzes.add(listToAdd[i]);
        listKey.currentState?.insertItem(i);
        notifyListeners();
      });
    }
  }

  void addQuiz(Quiz quiz) {
    _quizzes.add(quiz);
    listKey.currentState?.insertItem(_quizzes.length - 1);
    notifyListeners();
  }

  void updateQuizProgress(Quiz updatedQuiz) async {
    var quizToUpdate = _quizzes.where((quiz) => quiz.quizId == updatedQuiz.quizId).firstOrNull!;
    quizToUpdate.progress = await dbService.calculateProgressForQuiz(quizToUpdate.quizId!);
    notifyListeners();
  }

  void deleteQuiz(int quizId, int index) async {
    await dbService.deleteQuiz(quizId);
    GlobalStreams.deleteQuiz(_quizzes.elementAt(
        index)); //pass to global stream to remove from quizTitles in upload controller
    _quizzes.removeAt(index);
    listKey.currentState?.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            _buildRemovalAnimation(context, animation),
        duration: const Duration(milliseconds: 450));
    notifyListeners();
  }

  Widget _buildRemovalAnimation(
      BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        height: 50, // Or whatever height your list items have
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 54, 54).withOpacity(
              0.1), // Visual feedback that something is being removed
        ),
      ),
    );
  }
}
