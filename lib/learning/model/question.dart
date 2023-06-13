import 'package:wild_explorer/learning/model/answer.dart';

class Question {
  final String content;
  final int correctAnswerId;
  List<Answer> answerList;
  Question({
    required this.content,
    required this.correctAnswerId,
    required this.answerList,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<dynamic> answerJsonList = json["answerList"] ?? [];
    List<Answer> answerList = answerJsonList.map((answerJson) {
      return Answer.fromJson(answerJson);
    }).toList();

    return Question(
      answerList: answerList,
      content: json["content"],
      correctAnswerId: json["correctAnswerId"],
    );
  }
}
