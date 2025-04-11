import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pulse_mate/core/services/chat_service.dart';
import 'package:pulse_mate/core/services/sound_service.dart';
import 'package:pulse_mate/core/services/storage/chat_storage_service.dart';
import 'package:pulse_mate/core/services/storage/hive_user.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/data/models/chat_message_model.dart';
import 'package:pulse_mate/widgets/app_text.dart';
import 'package:pulse_mate/widgets/app_textfield.dart';
import 'package:pulse_mate/widgets/message_bubble.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String sender;
  final HiveUser user;
  final String receiver;
  final String chatName;
  const ChatDetailsScreen({
    super.key,
    required this.sender,
    required this.receiver,
    required this.chatName,
    required this.user,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen>
    with TickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  final SoundService _soundService = SoundService();
  final ChatStorageService _chatStorageService = ChatStorageService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    ChatService().addSingleUserToChatList(widget.user);
    _chatService.connect(widget.sender, widget.receiver);

    // Load existing messages from Hive
    _loadChatHistory();

    // Set listener for receiving messages
    _chatService.onMessageReceived = (sender, message) {
      // Immediately add message to UI
      _addMessage(sender, message, false, animate: true);
      _soundService.playMessageSound();
    };
  }

  void _loadChatHistory() {
    // Get messages from Hive storage
    final chatMessages =
        _chatStorageService.getChatMessages(widget.sender, widget.receiver);

    // Convert to the format used by the UI
    for (final msg in chatMessages) {
      final AnimationController animController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
        value: 1.0, // Start fully visible since these are loaded messages
      );

      final Animation<double> animation = CurvedAnimation(
        parent: animController,
        curve: Curves.easeOutCubic,
      );

      final messageMap = {
        "sender": msg.sender == widget.sender ? "You" : msg.sender,
        "message": msg.message,
        "timestamp": msg.timestamp,
        "status": ChatMessage.intToMessageStatus(msg.status),
        "animation": animation,
        "animController": animController,
      };

      messages.add(messageMap);
    }

    if (mounted) {
      setState(() {});
      // Scroll to bottom after loading messages
      if (messages.isNotEmpty) {
        _scrollToBottom();
      }
    }
  }

  @override
  void dispose() {
    // Dispose all animation controllers to prevent memory leaks
    for (var msg in messages) {
      if (msg["animController"] != null) {
        msg["animController"].dispose();
      }
    }
    _chatService.close();
    _soundService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(String sender, String message, bool isSent,
      {bool animate = true}) {
    final AnimationController animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    final Animation<double> animation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeOutCubic,
    );

    final MessageStatus initialStatus =
        isSent ? MessageStatus.sending : MessageStatus.delivered;

    final newMessage = {
      "sender": sender,
      "message": message,
      "timestamp": DateTime.now(),
      "status": initialStatus,
      "animation": animation,
      "animController": animController,
    };

    setState(() {
      messages.add(newMessage);
    });

    // Save message to Hive storage
    _saveMessageToHive(sender, message, initialStatus);

    // Start animation immediately
    if (animate) {
      animController.forward();
    } else {
      // If no animation needed, set to completed state
      animController.value = 1.0;
    }

    // Scroll to bottom immediately after adding message
    _scrollToBottom();

    // Simulate message status change for sent messages
    if (isSent) {
      // Update status to sent after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            newMessage["status"] = MessageStatus.sent;
          });

          // Update status in Hive
          _updateMessageStatus(sender, message,
              newMessage["timestamp"] as DateTime, MessageStatus.sent);

          // Update status to delivered after another short delay
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                newMessage["status"] = MessageStatus.delivered;
              });

              // Update status in Hive
              _updateMessageStatus(sender, message,
                  newMessage["timestamp"] as DateTime, MessageStatus.delivered);
            }
          });
        }
      });
    }
  }

  void _saveMessageToHive(String sender, String message, MessageStatus status) {
    // Convert UI sender name to actual sender ID
    final actualSender = sender == "You" ? widget.sender : sender;

    // Create ChatMessage object
    final chatMessage = ChatMessage(
      sender: actualSender,
      receiver: sender == "You" ? widget.receiver : widget.sender,
      message: message,
      timestamp: DateTime.now(),
      status: ChatMessage.messageStatusToInt(status),
    );

    // Save to Hive
    _chatStorageService.saveMessage(chatMessage);
  }

  void _updateMessageStatus(String sender, String message, DateTime timestamp,
      MessageStatus newStatus) {
    // This is a simplified approach. In a real app, you'd need a more robust way to identify messages
    // For example, using a unique message ID

    // Get all messages from storage
    final chatMessages =
        _chatStorageService.getChatMessages(widget.sender, widget.receiver);

    // Find the message that matches our criteria
    for (final msg in chatMessages) {
      if (msg.message == message &&
          msg.timestamp.isAtSameMomentAs(timestamp) &&
          (msg.sender == (sender == "You" ? widget.sender : sender))) {
        // Update the message status
        final key = Hive.box<ChatMessage>('chat_messages').keyAt(
            Hive.box<ChatMessage>('chat_messages')
                .values
                .toList()
                .indexOf(msg));

        _chatStorageService.updateMessageStatus(key, newStatus);
        break;
      }
    }
  }

  void _scrollToBottom() {
    Future.microtask(() {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Clear input field immediately for better UX
    _messageController.clear();

    // Add message to UI immediately
    _addMessage("You", message, true, animate: true);

    // Send message to service
    _chatService.sendMessage(widget.sender, widget.receiver, message);
  }

  @override
  Widget build(BuildContext context) {
    final Dimensions appDimension = Dimensions(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: appDimension.width * 0.1,
                width: appDimension.width * 0.1,
                margin: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
                alignment: Alignment.bottomCenter,
                child: Icon(
                  Iconsax.arrow_left_1,
                  color: AppColors.red,
                  size: appDimension.width * 0.07,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: appText(
                textName: widget.chatName,
                textStyle: TextStyle(
                  fontFamily: AppConstants.appFont,
                  fontSize: appDimension.h3,
                  fontWeight: Dimensions.fontBold,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            height: appDimension.width * 0.13,
            width: appDimension.width * 0.13,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: const Icon(
              Iconsax.element_equal,
              color: AppColors.red,
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
        ),
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: appText(
                        textName: "No messages yet",
                        textStyle: TextStyle(
                          fontFamily: AppConstants.appFont,
                          fontSize: appDimension.h5,
                          color: AppColors.inactive,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final bool isSender = msg["sender"] == "You";
                        return MessageBubble(
                          message: msg["message"],
                          isSender: isSender,
                          timestamp: msg["timestamp"],
                          animation: msg["animation"],
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.bg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: appTextFormField(
                      hint: 'Type a message...',
                      textColor: AppColors.inactive,
                      isSearchBox: false,
                      label: "Message",
                      textEditingController: _messageController,
                      onFieldSubmitted: (_) => _sendMessage(),
                      validator: (value) {
                        return null;
                      },
                      appDimensions: appDimension,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
