
import 'package:flutter/gestures.dart';
import 'package:qldt/presentation/pref/get_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

    static SharedPreferences prefs  = GetSharedPreferences.instance.prefs;

    static String? getToken() => prefs.getString("token");

    static String? getRole() => prefs.getString('role');

    static String? getId() => prefs.getString('id');

    static String? getEmail() => prefs.getString('email');

    static String? getFCMToken() => prefs.getString('fcmToken');

    static bool isTokenExpired() => true; // check here to force user login again

    static void deleteUserInfo() async { // logout
        await prefs.remove('token');
        await prefs.remove('role');
        await prefs.remove('id');
        await prefs.remove('email');
        await prefs.remove('fcmToken');
    }

    static void setUserInfo(String token, String role, String id, String email) async { // login
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        await prefs.setString('id', id);
        await prefs.setString('email', email);
    }

    static void setFCMToken(String fcmToken) async {
        await prefs.setString('fcmToken', fcmToken);
    }

    static bool checkFirstTime () => prefs.getBool("first_time") ?? false;
}