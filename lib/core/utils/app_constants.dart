import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String appFont = 'Sk-Modernist';
  static String serverAddress = dotenv.env['pulse_server']!;
  static String webSocketServerAddress = dotenv.env['pulse_websocket']!;
}
