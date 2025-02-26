import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulse_mate/core/utils/app_constants.dart';

class AuthService {
  Future<String> signIn(String email, String password, String name) async {
    try {
      String url = "${AppConstants.serverAddress}/user/signup";
      Map<String, String> body = {
        "name": name,
        "email": email,
        "password": password
      };
      final response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        debugPrint('Response Code : ${response.statusCode}');
        final String responseBody = response.body;
        return responseBody;
      }
      debugPrint('Response Code : ${response.statusCode}');
      throw Exception('Failed to load data');
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }
  }
}
