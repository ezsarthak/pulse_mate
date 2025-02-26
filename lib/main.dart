import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/utils/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      /// transparent status bar
      statusBarColor: AppColors.red,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}
