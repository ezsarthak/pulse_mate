import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePrefs {
  static SharedPreferences? _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static const tokenKey = "myAppTokenKeyISVeRYSaFE";

  setToken(String value) async {
    _preferences!.setString(tokenKey, value);
  }

  Future<String?> getToken() async {
    return _preferences!.getString(tokenKey);
  }

  void deleteToken() async {
    await _preferences!.remove(tokenKey);
  }
}
