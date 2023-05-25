class OpenAIModel {
  final String id;
  final int created;
  final String root;

  OpenAIModel({required this.id, required this.created, required this.root});

  factory OpenAIModel.fromJson(Map<String, dynamic> json) =>
      OpenAIModel(id: json["id"], created: json["created"], root: json["root"]);

  static List<OpenAIModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((e) => OpenAIModel.fromJson(e)).toList();
  }
}
