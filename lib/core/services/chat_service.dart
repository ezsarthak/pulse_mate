import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pulse_mate/core/services/home_screen_service.dart';
import 'package:pulse_mate/core/services/shared_preferences.dart';
import 'package:pulse_mate/core/services/storage/hive_user.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  Future<List<User>> getFriends() async {
    final User user = await HomeScreenService().getUser();
    try {
      UserSimplePrefs simplePrefs = UserSimplePrefs();
      String? token;
      token = await simplePrefs.getToken();
      String url = "${AppConstants.serverAddress}/friends?"
          "&token=${Uri.encodeComponent(token!)}"
          "&gender=${Uri.encodeComponent(user.gender)}";
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final List friendsList = json.decode(response.body);

        return friendsList.map((json) => User.fromJson(json)).toList();
      } else {
        log(response.statusCode.toString());
        throw Exception("Invalid response");
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  late WebSocketChannel _channel;
  Function(String sender, String message)? onMessageReceived;

  void connect(String userId, String receiver) {
    _channel = IOWebSocketChannel.connect(AppConstants.webSocketServerAddress);

    // Register user
    _channel.sink.add(jsonEncode({"type": "register", "userId": userId}));

    // Listen for incoming messages
    _channel.stream.listen((message) {
      print("Received: $message");
      final data = jsonDecode(message);

      if (data.containsKey("from") &&
          data.containsKey("message") &&
          data["from"] == receiver) {
        onMessageReceived?.call(data["from"], data['message']);
      }
    });
  }

  void sendMessage(String sender, String receiver, String message) {
    final data = jsonEncode({
      "type": "private_message",
      "to": receiver,
      "message": message,
    });
    _channel.sink.add(data);
  }

  void close() {
    _channel.sink.close();
  }

  void saveUniqueChatUsersFromSnapshot(AsyncSnapshot snapshot) async {
    final box = Hive.box<HiveUser>('chatBox');
    final existingEmails = box.values.map((u) => u.email).toSet();

    for (var user in snapshot.data!) {
      if (!existingEmails.contains(user.email)) {
        final hiveUser = HiveUser(
          id: user.id,
          email: user.email,
          name: user.name,
          age: user.age,
          gender: user.gender,
          location: user.location,
          interests: List<String>.from(user.interests),
          iat: user.iat,
        );
        await box.add(hiveUser);
      }
    }
  }

  Future<void> addSingleUserToChatList(HiveUser user) async {
    final box = Hive.box<HiveUser>('chatBox');
    final existingEmails = box.values.map((u) => u.email).toSet();

    if (!existingEmails.contains(user.email)) {
      await box.add(user);
    }
  }

  Future<List<HiveUser>> getChatUserList() async {
    final box = Hive.box<HiveUser>('chatBox');
    return box.values.toList();
  }
}
