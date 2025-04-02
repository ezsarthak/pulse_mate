import 'dart:convert';
import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:pulse_mate/core/services/shared_preferences.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/data/models/profile.dart';
import 'package:pulse_mate/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class HomeScreenService {
  Future<User> getUser() async {
    UserSimplePrefs simplePrefs = UserSimplePrefs();
    String? token;
    token = await simplePrefs.getToken();
    if (token == null) throw Exception("User Not Logged In");
    final jwt = JWT.decode(token).payload;
    final User user = User(
        id: jwt['_id'].toString(),
        email: jwt['email'].toString(),
        name: jwt['name'].toString(),
        age: jwt['age'].toString(),
        gender: jwt['gender'].toString(),
        location: jwt['location'].toString(),
        interests: List<String>.from(jwt["interests"]),
        iat: jwt['iat'].toString());
    return user;
  }

  static Future<List<Profile>> getData() async {
    try {
      UserSimplePrefs simplePrefs = UserSimplePrefs();
      String? token;

      token = await simplePrefs.getToken();
      if (token == null) throw Exception("User Not Logged In");
      final jwt = JWT.decode(token).payload;
      final User user = User(
          id: jwt['_id'].toString(),
          email: jwt['email'].toString(),
          name: jwt['name'].toString(),
          age: jwt['age'].toString(),
          gender: jwt['gender'].toString(),
          location: jwt['location'].toString(),
          interests: List<String>.from(jwt["interests"]),
          iat: jwt['iat'].toString());

      String url = "${AppConstants.serverAddress}/filter-users?"
          "&token=${Uri.encodeComponent(token)}"
          "&location=${Uri.encodeComponent(user.location)}"
          "&gender=${Uri.encodeComponent(user.gender)}"
          "&interests=${jsonEncode(user.interests)}"
          "&age=${Uri.encodeComponent(user.age.toString())}";

      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey("users") &&
            responseData["users"] is List) {
          final List<dynamic> usersList = responseData["users"];
          return usersList.map((json) => Profile.fromJson(json)).toList();
        } else {
          log(response.statusCode.toString());
          throw Exception(
              "Invalid response format: 'users' key not found or not a list");
        }
      }
      return [];
    } catch (e, stackTrace) {
      debugPrint("Error fetching users: $e");
      log("Error stack trace: $stackTrace");
      rethrow;
    }
  }
}
