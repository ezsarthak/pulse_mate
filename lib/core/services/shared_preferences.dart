import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePrefs {
  static SharedPreferences? _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static const tokenKey = "myAppTokenKeyISVeRYSaFE";
  static const chatListKey = "myChatLIsTKeyISVeRYSaFE";
  setToken(String value) async {
    _preferences!.setString(tokenKey, value);
  }

  Future<String?> getToken() async {
    return _preferences!.getString(tokenKey);
  }

  void deleteToken() async {
    await _preferences!.remove(tokenKey);
  }

  Future<List<String>> getChatList() async {
    return _preferences!.getStringList(chatListKey) ?? [];
  }

  setChatList(List<String> value) async {
    _preferences!.setStringList(chatListKey, value);
  }

  deleteChatList() async {
    await _preferences!.remove(chatListKey);
  }
}
