import 'package:flutter/material.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/widgets/app_text.dart';

class MatchOverlay extends StatelessWidget {
  final String firstUserImage;
  final String secondUserImage;
  final VoidCallback onSayHello;
  final VoidCallback onKeepSwiping;

  const MatchOverlay({
    super.key,
    required this.firstUserImage,
    required this.secondUserImage,
    required this.onSayHello,
    required this.onKeepSwiping,
  });

  @override
  Widget build(BuildContext context) {
    Dimensions appDimensions = Dimensions(context);
    return IntrinsicHeight(
      child: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          // Photo cards with hearts
          Stack(
            alignment: Alignment.center,
            children: [
              // First photo card (tilted right)
              Transform.rotate(
                angle: 0.25,
                child: Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: _buildPhotoCard(
                    firstUserImage,
                    Alignment.topRight,
                  ),
                ),
              ),
              // Second photo card (tilted left)
              Transform.rotate(
                angle: -0.25,
                child: Padding(
                  padding: const EdgeInsets.only(right: 60.0),
                  child: _buildPhotoCard(
                    secondUserImage,
                    Alignment.bottomLeft,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Match text
          appText(
            textName: "It's a Match !!",
            textStyle: TextStyle(
              fontSize: appDimensions.h3,
              fontWeight: Dimensions.fontBold,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 8),
          appText(
            textName: "Start a conversation now with each other",
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontSize: appDimensions.h5,
              color: AppColors.inactive,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          // Action buttons
          ElevatedButton(
            onPressed: onSayHello,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              elevation: 0,
              foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: appText(
              textName: "Say hello",
              textStyle: TextStyle(fontSize: appDimensions.h4),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onKeepSwiping,
            style: TextButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.red.withValues(alpha: 0.15),
              foregroundColor: AppColors.red,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: appText(
              textName: "Keep swiping",
              textStyle: TextStyle(fontSize: appDimensions.h4),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(String imageUrl, Alignment heartAlignment) {
    return Container(
      width: 200,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              spreadRadius: 4),
        ],
      ),
      child: Stack(
        children: [
          // Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              imageUrl,
              width: 200,
              height: 280,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
          ),
          // Heart icon
          Positioned(
            top: heartAlignment == Alignment.topRight ? 12 : null,
            right: heartAlignment == Alignment.topRight ? 12 : null,
            bottom: heartAlignment == Alignment.bottomLeft ? 12 : null,
            left: heartAlignment == Alignment.bottomLeft ? 12 : null,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                color: AppColors.red,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
