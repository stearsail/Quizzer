import 'dart:convert';

class Quiz {
  int? quizId;
  String title;
  String sourceFile;

  Quiz({
    this.quizId,
    required this.title,
    required this.sourceFile
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'sourceFile': sourceFile,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      quizId: map['quizId'] as int,
      title: map['title'] as String,
      sourceFile: map['sourceFile'] as String,
    );
  }
}

class Question {
  int? questionId;
  int quizId;
  String questionText;
  List<Map<String, String>>
      choices; // Each choice is a Map with 'choiceId' and 'choiceText'
  String correctChoice;
  String? selectedChoice;

  Question(
      {this.questionId,
      required this.quizId,
      required this.questionText,
      required this.choices,
      required this.correctChoice,
      this.selectedChoice});

//factory function to extract choices from list of choices contained in JSON object
  factory Question.fromJson(Map<String, dynamic> json, int quizId) {
    List<dynamic> rawChoices = json['choices'] as List<dynamic>;
    List<Map<String, String>> choices = rawChoices.map((dynamic rawChoice) {
      Map<String, dynamic> choice = rawChoice as Map<String, dynamic>;
      return {
        'choiceId': choice['choiceId'] as String,
        'choiceText': choice['choiceText'] as String,
      };
    }).toList();
    return Question(
      quizId: quizId,
      questionText: json['questionText'] as String,
      choices: choices,
      correctChoice: json['correctAnswer'] as String,
    );
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['questionId'] as int,
      quizId: map['quizId'] as int,
      questionText: map['questionText'] as String,
      choices: (json.decode(map['choices'] as String) as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      correctChoice: map['correctChoice'] as String,
      selectedChoice: map['selectedChoice'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'questionText': questionText,
      'choices': json.encode(choices), // Serializing choices to a JSON string
      'correctChoice': correctChoice,
      'selectedChoice': selectedChoice
    };
  }
}
