import 'package:flutter/material.dart';
import 'package:pulse_mate/presentation/screens/login_screen.dart';
import 'package:pulse_mate/presentation/screens/signup_flow.dart';
import 'package:pulse_mate/presentation/screens/signup_screen.dart';
import 'package:pulse_mate/presentation/screens/welcome_screen.dart';
import 'package:pulse_mate/widgets/app_text.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/signupFlow':
        return MaterialPageRoute(builder: (_) => const SignupFlow());
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
