import 'package:flutter/material.dart';
import 'package:pulse_mate/presentation/screens/signup_screen.dart';
import 'package:pulse_mate/presentation/screens/welcome_screen.dart';
import 'package:pulse_mate/widgets/app_text.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: appText(
                          textName: 'No route defined for ${settings.name}')),
                ));
    }
  }
}
