import 'package:flutter/material.dart';
import 'package:pulse_mate/core/services/chat_service.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String sender;
  final String receiver;
  const ChatDetailsScreen({super.key, required this.sender, required this.receiver});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    _chatService.connect(widget.sender);

    // Set listener for receiving messages
    _chatService.onMessageReceived = (sender, message) {
      setState(() {
        messages.add({"sender": sender, "message": message});
      });
    };
  }

  @override
  void dispose() {
    _chatService.close();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      _chatService.sendMessage(widget.sender, widget.receiver, message);
      setState(() {
        messages.add({"sender": "You", "message": message});
      });
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(msg["sender"]!),
                  subtitle: Text(msg["message"]!),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Enter message"),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
