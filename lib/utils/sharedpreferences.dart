import 'package:shared_preferences/shared_preferences.dart';

class SharedServices2 {
  SharedPreferences preferences;
  Future<bool> getSharedPreferencesInstance() async {
    preferences = await SharedPreferences.getInstance().catchError((e) {
      print("shared preferences=$e");
      return false;
    });

    return true;
  }

  Future clearToken() async {
    await preferences.clear();
  }

  setToken(String token) async {
    preferences.setString("token", token);
  }

  Future<String> get token async => preferences.getString("token");
}
