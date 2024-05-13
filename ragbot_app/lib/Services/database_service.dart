import 'package:ragbot_app/Models/choice.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ragbot_app/Models/quiz.dart';
import 'package:ragbot_app/Models/question.dart';

class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService _instance =
      DatabaseService._privateConstructor();

  factory DatabaseService() {
    return _instance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB('quiz_db.db');
    return _database!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    //when necessary debug
    // await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Quizzes(quizId INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      sourceFile TEXT NOT NULL);
    ''');
    await db.execute('''
      CREATE TABLE Questions(questionId INTEGER PRIMARY KEY AUTOINCREMENT,
      quizId INTEGER, 
      questionText TEXT NOT NULL, 
      choices TEXT NOT NULL, 
      correctChoice CHAR(1) NOT NULL,
      selectedChoice CHAR(1),
      FOREIGN KEY(quizId) REFERENCES Quizzes(quizId) ON DELETE CASCADE);
      );
    ''');
  }

  Future<int> insertQuiz(Quiz quiz) async {
    final db = await database;
    return await db.insert('Quizzes', quiz.toMap());
  }

  Future<int> insertQuestion(Question question) async {
    final db = await database;
    return await db.insert('Questions', question.toMap());
  }

  Future<List<Question>> getQuestionsForQuiz(int quizId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('Questions', where: 'quizId = ?', whereArgs: [quizId]);
    List<Question> resultList =
        List.generate(maps.length, (i) => Question.fromMap(maps[i]));
    for (var question in resultList) {
      for (var choice in question.choices) {
        var choiceId = choice["choiceId"]!;
        var choiceText = choice["choiceText"]!;
        question.choiceList.add(Choice(
            choiceId: choiceId, choiceText: choiceText, newIsSelected: false));
      }
    }
    return resultList;
  }

  Future<List<Quiz>> getAllQuizzes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Quizzes');
    List<Quiz> quizzes = [];
    for (var map in maps) {
      Quiz newQuiz = Quiz.fromMap(map);
      newQuiz.progress = await calculateProgressForQuiz(newQuiz.quizId!);
      quizzes.add(newQuiz);
    }
    return quizzes;
  }

  Future<void> deleteQuiz(int quizId) async {
    final db = await database;
    await db.delete(
      'Quizzes',
      where: 'quizId = ?',
      whereArgs: [quizId],
    );
  }

  Future<String> calculateProgressForQuiz(int quizId) async {
    List<Question> questions = await getQuestionsForQuiz(quizId);
    var correctAnswers = questions
        .where((element) => element.selectedChoice == element.correctChoice);
    return "${correctAnswers.length}/${questions.length} correct answers - Score: ${((correctAnswers.length / questions.length) * 100).floor()}%";
  }

  Future<void> updateSolvedQuiz(int quizId, List<Question> questions) async {
    try {
      final db = await database;

      //extract questions by quizId
      for (var question in questions) {
        var selectedChoice =
            question.choiceList.where((x) => x.isSelected == true).firstOrNull;

        //save selected choice and set the rest to false
        await db.update(
            'Questions', {'selectedChoice': selectedChoice!.choiceId},
            where: 'questionId = ?', whereArgs: [question.questionId]);
      }

    } catch (e) {
      print('Error submitting solved quiz: $e');
    }
  }
}
