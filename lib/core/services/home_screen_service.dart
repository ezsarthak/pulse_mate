import 'package:pulse_mate/core/services/shared_preferences.dart';

class HomeScreenService {
  static Future<String> getData() async {
    UserSimplePrefs simplePrefs = UserSimplePrefs();
    String? token;
    token = await simplePrefs.getToken();
    if (token != null) {
      return token;
    }
    throw Exception("User Not Logged In");
  }
}
