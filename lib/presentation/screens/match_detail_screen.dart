import 'package:flutter/material.dart';
import 'package:pulse_mate/core/services/storage/hive_user.dart';
import 'package:pulse_mate/core/utils/app_colors.dart';
import 'package:pulse_mate/core/utils/dimensions.dart';
import 'package:pulse_mate/core/utils/extensions.dart';
import 'package:pulse_mate/widgets/app_text.dart';

import 'chat_details_screen.dart';

class MatchDetailScreen extends StatelessWidget {
  final HiveUser currentMatch;
  const MatchDetailScreen({super.key, required this.currentMatch});

  @override
  Widget build(BuildContext context) {
    Dimensions appDimensions = Dimensions(context);
    Widget buildActionButton(
        IconData icon, Color iconColor, Color bgColor, GestureTapCallback onTap,
        {bool isLarge = false}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: isLarge ? 60 : 50,
          height: isLarge ? 60 : 50,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: isLarge ? 30 : 24,
          ),
        ),
      );
    }

    Widget buildInterestChip(String label) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: appText(
          textName: label.capitalizeFirstOfEach,
          textStyle: TextStyle(
              fontSize: appDimensions.h6,
              fontWeight: Dimensions.fontRegular,
              color: AppColors.black),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image with Action Buttons
            Stack(
              children: [
                // Profile Image
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(currentMatch.imgUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Action Buttons
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildActionButton(
                          Icons.close, AppColors.orange, AppColors.white, () {
                        Navigator.pop(context);
                      }),
                      const SizedBox(width: 20),
                      buildActionButton(
                          Icons.favorite, AppColors.white, AppColors.red, () {
                        Navigator.pop(context);
                      }, isLarge: true),
                      const SizedBox(width: 20),
                      buildActionButton(
                          Icons.message, AppColors.purple, AppColors.white, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatDetailsScreen(
                                      sender: "jsakbd",
                                      receiver: currentMatch.email,
                                      chatName: currentMatch.name,
                                      user: currentMatch,
                                    )));
                      }),
                    ],
                  ),
                ),
              ],
            ),

            // Profile Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Age
                  appText(
                    textName: "${currentMatch.name}, ${currentMatch.age}",
                    textStyle: TextStyle(
                        fontSize: appDimensions.h3,
                        fontWeight: Dimensions.fontBold,
                        color: AppColors.red),
                  ),
                  const SizedBox(height: 4),

                  // Profession
                  appText(
                    textName: currentMatch.bio!,
                    textStyle: TextStyle(
                      fontSize: appDimensions.h6,
                      color: AppColors.inactive,
                      fontWeight: Dimensions.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  Row(
                    children: [
                      appText(
                        textName: currentMatch.location,
                        textStyle: TextStyle(
                          fontSize: appDimensions.h4,
                          color: AppColors.red.withValues(alpha: 0.75),
                          fontWeight: Dimensions.fontBold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // About
                  appText(
                    textName: 'About',
                    textStyle: TextStyle(
                      fontSize: appDimensions.h6,
                      fontWeight: Dimensions.fontBold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  appText(
                    textName: currentMatch.about!,
                    textStyle: TextStyle(
                        fontSize: appDimensions.h6,
                        fontWeight: Dimensions.fontRegular,
                        color: AppColors.black),
                  ),
                  const SizedBox(height: 16),

                  // Interests
                  appText(
                    textName: 'Interests',
                    textStyle: TextStyle(
                      fontSize: appDimensions.h6,
                      fontWeight: Dimensions.fontBold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        currentMatch.interests.map(buildInterestChip).toList(),
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
