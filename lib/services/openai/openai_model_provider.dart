import 'package:flutter/foundation.dart';
import 'package:wild_explorer/chatopenai/models/openai_model.dart';
import 'package:wild_explorer/services/api/api_service.dart';

class OpenAIModelProvider extends ChangeNotifier {
  List<OpenAIModel> models = [];
  String currentModel = "text-davinci-003";
  List<OpenAIModel> get getModelList => models;

  String get getCurrentModel => currentModel;

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  Future<List<OpenAIModel>> getAllModels() async {
    models = await ApiService.getModels();
    return models;
  }
}
