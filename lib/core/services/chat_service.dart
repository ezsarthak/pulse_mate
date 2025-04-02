import 'dart:convert';
import 'dart:developer';
import 'package:pulse_mate/core/services/home_screen_service.dart';
import 'package:pulse_mate/core/services/shared_preferences.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService{
  Future<List<User>> getFriends() async{
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
        throw Exception(
            "Invalid response");
      }
    }catch(e){
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  late WebSocketChannel _channel;
  Function(String sender, String message)? onMessageReceived;

  void connect(String userId) {
    _channel = IOWebSocketChannel.connect("ws://192.168.1.5:3000");

    // Register user
    _channel.sink.add(jsonEncode({"type": "register", "sender": userId}));

    // Listen for incoming messages
    _channel.stream.listen((message) {
      print("Received: $message");
      final data = jsonDecode(message);

      if (data.containsKey("sender") && data.containsKey("content")) {
        onMessageReceived?.call(data["sender"], data["content"]);
      }
    });
  }

  void sendMessage(String sender, String receiver, String message) {
    final data = jsonEncode({
      "type": "message",
      "sender": sender,
      "receiver": receiver,
      "content": message,
    });
    _channel.sink.add(data);
  }

  void close() {
    _channel.sink.close();
  }
  }
