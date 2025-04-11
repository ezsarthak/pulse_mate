import 'package:flutter/material.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/app_constants.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:intl/intl.dart';

enum MessageStatus { sending, sent, delivered, read }

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final DateTime timestamp;
  final Animation<double> animation;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.timestamp,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final Dimensions appDimension = Dimensions(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              isSender
                  ? (1 - animation.value) * 20
                  : (animation.value - 1) * 20,
              0),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: appDimension.width * 0.02,
            vertical: appDimension.height * 0.005,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: appDimension.width * 0.04,
            vertical: appDimension.height * 0.01,
          ),
          constraints: BoxConstraints(
            maxWidth: appDimension.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isSender
                ? AppColors.red.withOpacity(0.9)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isSender
                  ? const Radius.circular(16)
                  : const Radius.circular(0),
              bottomRight: isSender
                  ? const Radius.circular(0)
                  : const Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontFamily: AppConstants.appFont,
                  fontSize: appDimension.h5,
                  color: isSender ? Colors.white : AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('HH:mm').format(timestamp),
                    style: TextStyle(
                      fontFamily: AppConstants.appFont,
                      fontSize: appDimension.h7,
                      color: isSender
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
