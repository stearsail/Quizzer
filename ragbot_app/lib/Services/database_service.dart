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

  Future<Database?> initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      //when necessary debug
      // await deleteDatabase(path);
      return await openDatabase(path, version: 1, onCreate: _createDB);
    } catch (e) {
      print('Error submitting solved quiz: $e');
      return null;
    }
  }

  Future _createDB(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE Quizzes(quizId INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      sourceFile TEXT NOT NULL,
      wasTaken INTEGER NOT NULL);
    ''');
      await db.execute('''
      CREATE TABLE Questions(questionId INTEGER PRIMARY KEY AUTOINCREMENT,
      quizId INTEGER, 
      questionText TEXT NOT NULL, 
      FOREIGN KEY(quizId) REFERENCES Quizzes(quizId) ON DELETE CASCADE);
      );
    ''');
      await db.execute('''
      CREATE TABLE Choices(choiceId INTEGER PRIMARY KEY AUTOINCREMENT,
      questionId INTEGER, 
      choiceText TEXT NOT NULL, 
      isSelected INTEGER NOT NULL, 
      isCorrectChoice INTEGER NOT NULL,
      FOREIGN KEY(questionId) REFERENCES Questions(questionId) ON DELETE CASCADE);
      );
    ''');
    } catch (e) {
      print('Error submitting solved quiz: $e');
    }
  }

  Future<int?> insertQuiz(Quiz quiz) async {
    try {
      final db = await database;
      return await db.insert('Quizzes', quiz.toMap());
    } catch (e) {
      print('Error submitting solved quiz: $e');
      return null;
    }
  }

  Future<int?> insertQuestion(Question question) async {
    final db = await database;
    return await db.insert('Questions', question.toMap());
  }

  Future<int?> insertChoice(Choice choice) async {
    try {
      final db = await database;
      return await db.insert('Choices', choice.toMap());
    } catch (e) {
      print('Error submitting solved quiz: $e');
      return null;
    }
  }

  Future<List<Question>?> getQuestionsForQuiz(int quizId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query('Questions', where: 'quizId = ?', whereArgs: [quizId]);
      List<Question> resultList =
          List.generate(maps.length, (i) => Question.fromMap(maps[i]));
      return resultList;
    } catch (e) {
      print('Error submitting solved quiz: $e');
      return null;
    }
  }

  Future<List<Choice>?> getChoicesForQuestion(int questionId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db
          .query('Choices', where: 'questionId = ?', whereArgs: [questionId]);
      List<Choice> resultList =
          List.generate(maps.length, (i) => Choice.fromMapWithId(maps[i]));
      return resultList;
    } catch (e) {
      print('Error submitting solved quiz: $e');
      return null;
    }
  }

  Future<List<Quiz>?> getAllQuizzes() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('Quizzes');
      List<Quiz> quizzes = [];
      for (var map in maps) {
        Quiz newQuiz = Quiz.fromMap(map);
        newQuiz.questionList = await getQuestionsForQuiz(newQuiz.quizId!);
        for (var question in newQuiz.questionList!) {
          question.choiceList =
              await getChoicesForQuestion(question.questionId!);
        }
        quizzes.add(newQuiz);
      }
      return quizzes;
    } catch (e) {
      print('Error submitting solved quiz: $e');
      return null;
    }
  }

  Future<Quiz?> getQuiz(int quizId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> queryResult =
          await db.query('Quizzes', where: 'quizId = ?', whereArgs: [quizId]);
      final Map<String, dynamic>? map = queryResult.firstOrNull;
      if (map == null) throw Exception("Failed to retrieve quiz by Id!");

      Quiz result = Quiz.fromMap(map);
      result.questionList = await getQuestionsForQuiz(result.quizId!);
      for (var question in result.questionList!) {
        question.choiceList = await getChoicesForQuestion(question.questionId!);
      }

      return result;
    } catch (e) {
      print('Error submitting solved quiz: $e');
      return null;
    }
  }

  Future<String> calculateProgressForQuiz(int quizId) async {
    Quiz? quiz = await getQuiz(quizId);
    int nrQuestions = quiz!.questionList!.length;
    int correctAnswers = 0;

    for (var question in quiz.questionList!) {
      for (var choice in question.choiceList!) {
        if (choice.isSelected && choice.isCorrectChoice) {
          correctAnswers++;
          break;
        }
      }
    }
    return "${correctAnswers}/${nrQuestions} correct answers - Score: ${((correctAnswers / nrQuestions) * 100).floor()}%";
  }

  Future<void> deleteQuiz(int quizId) async {
    try {
      final db = await database;
      await db.delete(
        'Quizzes',
        where: 'quizId = ?',
        whereArgs: [quizId],
      );
    } catch (e) {
      print('Error submitting solved quiz: $e');
    }
  }

  Future<void> updateSolvedQuiz(Quiz quiz) async {
    try {
      final db = await database;

      db.update('Quizzes', {'wasTaken': true},
          where: 'quizId = ?', whereArgs: [quiz.quizId]);

      for (var question in quiz.questionList!) {
        for (var choice in question.choiceList!) {
          await db.update('Choices', {'isSelected': choice.isSelected},
              where: 'choiceId = ?', whereArgs: [choice.choiceId]);
        }
      }
    } catch (e) {
      print('Error submitting solved quiz: $e');
    }
  }
}
