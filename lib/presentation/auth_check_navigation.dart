import 'package:flutter/material.dart';
import 'package:pulse_mate/core/services/home_screen_service.dart';
import 'package:pulse_mate/data/models/profile.dart';
import 'package:pulse_mate/presentation/screens/navigation_screen.dart';
import 'package:pulse_mate/presentation/screens/welcome_screen.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Profile?>>(
      stream: HomeScreenService.getData().asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Loading state
        }
        if (snapshot.hasData) {
          return NavigationScreen(); // User is logged in
        } else {
          return const WelcomeScreen(); // User is not logged in
        }
      },
    );
  }
}