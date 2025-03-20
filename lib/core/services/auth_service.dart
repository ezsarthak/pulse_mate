import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_mate/core/services/shared_preferences.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';

class AuthService {
  UserSimplePrefs simplePrefs = UserSimplePrefs();
  Future<String> signUp(String email, String password, String name, String age,
      String location, String gender, List<String> interests) async {
    String url = "${AppConstants.serverAddress}/user/signup";
    Map<String, dynamic> bodyTO = {
      "name": name,
      "age": age,
      "gender": gender,
      "location": location,
      "interests": interests.toList(),
      "email": email,
      "password": password
    };
    String jsonBody = jsonEncode(bodyTO);
    final response = await http.post(
      Uri.parse(url),
      body: jsonBody,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      debugPrint('Response Code : ${response.statusCode}');
      final String responseBody = response.body;
      String token = jsonDecode(responseBody)['jwtToken'];
      simplePrefs.setToken(token);
      return token;
    }
    debugPrint('Response Code : ${response.statusCode}');
    throw Exception(jsonDecode(response.body)['error']);
  }

  Future<String> login(String email, String password) async {
    String url = "${AppConstants.serverAddress}/user/login";
    Map<String, String> body = {"email": email, "password": password};
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      debugPrint('Response Code : ${response.statusCode}');
      final String responseBody = response.body;
      String token = jsonDecode(responseBody)['jwtToken'];
      simplePrefs.setToken(token);
      return token;
    }
    debugPrint('Response Code : ${response.statusCode}');
    throw Exception(jsonDecode(response.body)['error']);
  }
}
