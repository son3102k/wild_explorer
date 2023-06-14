class LessonDetail {
  String content;

  LessonDetail({required this.content});

  factory LessonDetail.fromJson(Map<String, dynamic> json) => LessonDetail(
        content: json["content"] ?? '',
      );
}
