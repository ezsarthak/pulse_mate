import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_mate/core/utils/app_constants.dart';

class AuthService {
  Future<String> signUp(String email, String password, String name, String age) async {

      String url = "${AppConstants.serverAddress}/user/signup";
      Map<String, String> body = {
        "name": name,
        "age": age,
        "email": email,
        "password": password
      };
      final response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        debugPrint('Response Code : ${response.statusCode}');
        final String responseBody = response.body;
        return jsonDecode(responseBody)['jwtToken'];
      }
      debugPrint('Response Code : ${response.statusCode}');
      throw Exception(jsonDecode(response.body)['error']);
  }
  Future<String> login(String email, String password) async {

    String url = "${AppConstants.serverAddress}/user/login";
    Map<String, String> body = {
      "email": email,
      "password": password
    };
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      debugPrint('Response Code : ${response.statusCode}');
      final String responseBody = response.body;
      return jsonDecode(responseBody)['jwtToken'];
    }
    debugPrint('Response Code : ${response.statusCode}');
    throw Exception(jsonDecode(response.body)['error']);
  }
}
