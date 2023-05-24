import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wild_explorer/constants/api.dart';
import 'package:wild_explorer/discovery/discovery_home_screen.dart';
import 'package:wild_explorer/discovery/models/entity.dart';
import 'package:http/http.dart' as http;

class ApiService {
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
}
