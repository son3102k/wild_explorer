import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wild_explorer/chatopenai/const/const.dart';
import 'package:wild_explorer/chatopenai/models/chat_model.dart';
import 'package:wild_explorer/chatopenai/models/openai_model.dart';
import 'package:wild_explorer/constants/api.dart';
import 'package:wild_explorer/discovery/discovery_home_screen.dart';
import 'package:wild_explorer/discovery/models/entity.dart';
import 'package:http/http.dart' as http;
import 'package:wild_explorer/learning/model/lesson_detail.dart';
import 'package:wild_explorer/learning/model/list_data.dart';
import 'package:wild_explorer/learning/model/question.dart';
import 'package:wild_explorer/model/app-user-info.dart';
import 'package:wild_explorer/services/auth/auth_user.dart';

class ApiService {
  Future<bool> setAppUserInfo(
      String name, String phoneNumber, String imageData) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      final Uri url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.setUserInfo);
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'name': name,
          'phoneNumber': phoneNumber,
          'imageData': imageData,
        }),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int code = result["code"];
        if (code == 0) {
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<AppUserInfo> getUserInfo() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      final Uri url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.getUserInfo);
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int code = result["code"];
        if (code == 0) {
          return AppUserInfo.fromJson(result["data"]);
        }
      }
      return AppUserInfo(
        email: "",
        avatarLink: "",
        phoneNumber: "",
        name: "",
      );
    } catch (_) {
      return AppUserInfo(
        email: "",
        avatarLink: "",
        phoneNumber: "",
        name: "",
      );
    }
  }

  Future<bool> register(AuthUser? authUser) async {
    if (authUser == null) {
      return false;
    }
    final Uri url = Uri.parse(ApiConstants.baseUrl + ApiConstants.register);
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'id': authUser.id,
          'email': authUser.email,
        }));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      int code = result["code"];
      if (code == 0) {
        return true;
      }
    }
    return false;
  }

  Future<LessonDetail> getLessonDetail(int id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      final Uri url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.getLessonDetail + id.toString());
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int code = result["code"];
        if (code == 0) {
          dynamic data = result["data"];
          if (data != null) {
            return LessonDetail.fromJson(data);
          }
        }
      }
      return LessonDetail(content: "");
    } catch (_) {
      return LessonDetail(content: "");
    }
  }

  Future<List<ListData>> getLessonListData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      final Uri url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.getLessonListData);
      List<ListData> lessonList = [];
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int code = result["code"];
        if (code == 0) {
          List<dynamic> listData = result["data"];
          if (listData.isNotEmpty) {
            for (int i = 0; i < listData.length; i++) {
              lessonList.add(ListData.fromJson(listData[i]));
            }
          }
        }
      }
      return lessonList;
    } catch (_) {
      return [];
    }
  }

  Future<List<Question>> getQuiz(int id) async {
    try {
      List<Question> questionList = [];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      final Uri url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.getQuizById + id.toString());
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int code = result["code"];
        if (code == 0) {
          List<dynamic> listJsonQuestion = result["data"];
          if (listJsonQuestion.isNotEmpty) {
            for (int i = 0; i < listJsonQuestion.length; i++) {
              questionList.add(Question.fromJson(listJsonQuestion[i]));
            }
          }
        }
      }
      return questionList;
    } catch (_) {
      return [];
    }
  }

  Future<List<ListData>> getQuizListData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      final Uri url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.getQuizListData);
      List<ListData> quizList = [];
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int code = result["code"];
        if (code == 0) {
          List<dynamic> listData = result["data"];
          if (listData.isNotEmpty) {
            for (int i = 0; i < listData.length; i++) {
              quizList.add(ListData.fromJson(listData[i]));
            }
          }
        }
      }
      return quizList;
    } catch (_) {
      return [];
    }
  }

  Future<Entity?> getEntityBy(String name) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      final Uri url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.getEntityByName + name);
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int code = result["code"];
        if (code == 0) {
          dynamic data = result["data"];
          return Entity.fromJson(data);
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<List<Entity>> getPopular(CategoryType categoryType) async {
    try {
      List<Entity> listEntity = <Entity>[];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      late final Uri url;
      if (categoryType == CategoryType.animal) {
        url = Uri.parse(
            ApiConstants.baseUrl + ApiConstants.getPopularAnimalEntityUrl);
      } else if (categoryType == CategoryType.plant) {
        url = Uri.parse(
            ApiConstants.baseUrl + ApiConstants.getPopularPlantEntityUrl);
      }
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int code = result["code"];
        if (code == 0) {
          List<dynamic> listEntityData = result["data"];
          for (int i = 0; i < listEntityData.length; i++) {
            listEntity.add(Entity.fromJson(listEntityData[i]));
          }
        }
      }
      return listEntity;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<Entity>> getRandomFive(CategoryType categoryType) async {
    try {
      List<Entity> listEntity = <Entity>[];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      late final Uri url;
      if (categoryType == CategoryType.animal) {
        url = Uri.parse(
            ApiConstants.baseUrl + ApiConstants.getFiveAnimalEntityUrl);
      } else if (categoryType == CategoryType.plant) {
        url = Uri.parse(
            ApiConstants.baseUrl + ApiConstants.getFivePlantEntityUrl);
      }
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        int code = result["code"];
        if (code == 0) {
          List<dynamic> listEntityData = result["data"];
          for (int i = 0; i < listEntityData.length; i++) {
            listEntity.add(Entity.fromJson(listEntityData[i]));
          }
        }
      }
      return listEntity;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static Future<List<OpenAIModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse(OpenAIEndpoints.getAllModels),
          headers: {'Authorization': "Bearer ${OpenAIEndpoints.API_KEY}"});

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse["error"]["message"]);
      }

      List tmp = [];
      for (var i in jsonResponse['data']) {
        tmp.add(i);
        // logger.warning(i["id"]);
      }

      return OpenAIModel.modelsFromSnapshot(tmp);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessage(
      {required String message,
      required String modelId,
      int maxTokens = 100}) async {
    try {
      log(message);
      var response = await http.post(Uri.parse(OpenAIEndpoints.sendMessage),
          headers: {
            "Authorization": 'Bearer ${OpenAIEndpoints.API_KEY}',
            "Content-Type": "application/json"
          },
          body: jsonEncode(
              {"model": modelId, "prompt": message, "max_tokens": maxTokens}));

      Map jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      if (jsonResponse['error'] != null) {
        log(jsonResponse["error"]["message"]);
        throw HttpException(jsonResponse["error"]["message"]);
      }

      List<ChatModel> chatList = [];

      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                msg: jsonResponse["choices"][index]["text"], chatIndex: 1));
      }
      return chatList;
    } catch (e) {
      rethrow;
    }
  }
}
