class Choice {
  int? choiceId;
  int questionId;
  String choiceText;
  bool isSelected;
  bool isCorrectChoice;

  Choice({
    this.choiceId,
    required this.questionId,
    required this.choiceText,
    required this.isSelected,
    required this.isCorrectChoice,
  });

  factory Choice.fromMap(Map<String, dynamic> map) {
    return Choice(
      questionId: map['questionId'] as int,
      choiceText: map['choiceText'] as String,
      isSelected: map['isSelected'] as int == 1,
      isCorrectChoice: map['isCorrectChoice'] as int == 1,
    );
  }

  factory Choice.fromMapWithId(Map<String, dynamic> map) {
    return Choice(
      choiceId: map['choiceId'] as int,
      questionId: map['questionId'] as int,
      choiceText: map['choiceText'] as String,
      isSelected: map['isSelected'] as int == 1,
      isCorrectChoice: map['isCorrectChoice'] as int == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'choiceText': choiceText,
      'isSelected': isSelected,
      'isCorrectChoice': isCorrectChoice
    };
  }
}
