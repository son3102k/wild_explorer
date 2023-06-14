class ListData {
  ListData({
    this.id = 0,
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = "",
    this.difficult = 1.0,
    this.type = DataType.quiz,
  });

  int id;
  String imagePath;
  String titleTxt;
  String subTxt;
  double difficult;
  DataType type;

  factory ListData.fromJson(Map<String, dynamic> json) => ListData(
        id: json["id"],
        imagePath: json["imageLink"] ?? '',
        titleTxt: json["name"],
        subTxt: '',
        difficult: json["level"],
        type: json["type"] == "quiz" ? DataType.quiz : DataType.lesson,
      );
}

enum DataType {
  quiz,
  lesson,
}
