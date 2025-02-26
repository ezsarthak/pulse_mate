import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulse_mate/presentation/screens/welcome_screen.dart';
import 'core/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pulse mate',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
