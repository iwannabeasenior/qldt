import 'package:shared_preferences/shared_preferences.dart';

class GetSharedPreferences {
  static final GetSharedPreferences _instance = GetSharedPreferences._internal();
  GetSharedPreferences._internal();
  SharedPreferences? _prefs;

  static GetSharedPreferences get instance => _instance;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  SharedPreferences get prefs => _prefs!;
}
