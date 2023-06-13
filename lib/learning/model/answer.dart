class Answer {
  final int id;
  final String content;
  Answer({
    required this.id,
    required this.content,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"],
        content: json["content"] ?? '',
      );
}
