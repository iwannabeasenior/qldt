
import 'package:qldt/presentation/pref/get_shared_preferences.dart';

class UserPreferences {

    static Future<String?> getToken() async => await GetSharedPreferences.instance.prefs.getString("token");

    static Future<bool> isTokenExpired() async => true;

    static void deleteToken() {}

    static void setToken(String token) async => await GetSharedPreferences.instance.prefs.setString("token", token);

    static Future<bool> checkFirstTime () async => await GetSharedPreferences.instance.prefs.getBool("first_time") ?? true;
}