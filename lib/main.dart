import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulse_mate/core/services/shared_preferences.dart';
import 'app.dart';
import 'core/utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePrefs.init();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.red,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}
