import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pulse_mate/data/models/chat_message_model.dart';
import 'package:pulse_mate/widgets/message_bubble.dart'; // Import the existing MessageStatus enum

class ChatStorageService {
  static const String _chatBoxName = 'chat_messages';

  // Initialize Hive and register adapters
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatMessageAdapter());
    await Hive.openBox<ChatMessage>(_chatBoxName);
  }

  // Get chat box
  Box<ChatMessage> get _chatBox => Hive.box<ChatMessage>(_chatBoxName);

  // Save a message to local storage
  Future<void> saveMessage(ChatMessage message) async {
    await _chatBox.add(message);
  }

  // Update message status
  Future<void> updateMessageStatus(
      int messageKey, MessageStatus newStatus) async {
    final message = _chatBox.get(messageKey);
    if (message != null) {
      final updatedMessage = ChatMessage(
        sender: message.sender,
        receiver: message.receiver,
        message: message.message,
        timestamp: message.timestamp,
        status: ChatMessage.messageStatusToInt(newStatus),
      );
      await _chatBox.put(messageKey, updatedMessage);
    }
  }

  // Get all messages for a specific chat (between two users)
  List<ChatMessage> getChatMessages(String user1, String user2) {
    // Get messages where either user is sender and the other is receiver
    return _chatBox.values
        .where((message) =>
            (message.sender == user1 && message.receiver == user2) ||
            (message.sender == user2 && message.receiver == user1))
        .toList()
      // Sort by timestamp
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  // Delete all messages for a specific chat
  Future<void> deleteChat(String user1, String user2) async {
    final messagesToDelete = _chatBox.values.where((message) =>
        (message.sender == user1 && message.receiver == user2) ||
        (message.sender == user2 && message.receiver == user1));

    for (final message in messagesToDelete) {
      final key = _chatBox.keyAt(_chatBox.values.toList().indexOf(message));
      await _chatBox.delete(key);
    }
  }

  // Delete all messages (clear chat history)
  Future<void> clearAllChats() async {
    await _chatBox.clear();
  }

  // Get all unique chats (conversations)
  List<Map<String, dynamic>> getAllChats(String currentUser) {
    final allMessages = _chatBox.values.toList();
    final Map<String, Map<String, dynamic>> uniqueChats = {};

    for (final message in allMessages) {
      final otherUser =
          message.sender == currentUser ? message.receiver : message.sender;

      // Skip if this is not a chat involving the current user
      if (message.sender != currentUser && message.receiver != currentUser) {
        continue;
      }

      // Create or update chat entry
      if (!uniqueChats.containsKey(otherUser)) {
        uniqueChats[otherUser] = {
          'user': otherUser,
          'lastMessage': message.message,
          'timestamp': message.timestamp,
          'unreadCount': message.sender != currentUser ? 1 : 0,
        };
      } else {
        final existingChat = uniqueChats[otherUser]!;
        final existingTimestamp = existingChat['timestamp'] as DateTime;

        // Update if this message is newer
        if (message.timestamp.isAfter(existingTimestamp)) {
          existingChat['lastMessage'] = message.message;
          existingChat['timestamp'] = message.timestamp;
        }

        // Increment unread count if message is from other user
        if (message.sender != currentUser) {
          existingChat['unreadCount'] =
              (existingChat['unreadCount'] as int) + 1;
        }
      }
    }

    // Convert to list and sort by most recent
    return uniqueChats.values.toList()
      ..sort((a, b) =>
          (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
  }
}
