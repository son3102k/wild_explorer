import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wild_explorer/constants/api.dart';
import 'package:wild_explorer/discovery/models/entity.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Entity>?> getFiveEntity() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idToken = prefs.getString('idToken');
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getEntityUrl);
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log(response.body.toString());
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
