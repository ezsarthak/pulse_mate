import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pulse_mate/core/services/shared_preferences.dart';
import 'package:pulse_mate/core/services/storage/chat_storage_service.dart';
import 'app.dart';
import 'core/services/storage/hive_user.dart';
import 'core/utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HiveUserAdapter());
  await ChatStorageService.init();

  await Hive.openBox<HiveUser>('chatBox');
  await Hive.openBox<HiveUser>('matchesBox');
  await dotenv.load(fileName: ".env");

  await UserSimplePrefs.init();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.red,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}
