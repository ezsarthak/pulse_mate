import 'package:hive/hive.dart';
import 'package:pulse_mate/widgets/message_bubble.dart'; // Import the existing MessageStatus enum

part 'chat_message_model.g.dart';

@HiveType(typeId: 1)
class ChatMessage {
  @HiveField(0)
  final String sender;

  @HiveField(1)
  final String receiver;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final int status; // 0: sending, 1: sent, 2: delivered, 3: read

  ChatMessage({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
    required this.status,
  });

  // Convert MessageStatus enum to int for storage
  static int messageStatusToInt(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return 0;
      case MessageStatus.sent:
        return 1;
      case MessageStatus.delivered:
        return 2;
      case MessageStatus.read:
        return 3;
      default:
        return 0;
    }
  }

  // Convert int back to MessageStatus enum
  static MessageStatus intToMessageStatus(int status) {
    switch (status) {
      case 0:
        return MessageStatus.sending;
      case 1:
        return MessageStatus.sent;
      case 2:
        return MessageStatus.delivered;
      case 3:
        return MessageStatus.read;
      default:
        return MessageStatus.sending;
    }
  }
}

// Removed the duplicate MessageStatus enum definition
