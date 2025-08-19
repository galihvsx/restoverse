import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  // Keys for preferences
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyDailyReminder = 'daily_reminder';
  static const String _keyFirstLaunch = 'first_launch';

  // Theme mode values
  static const String themeModeLight = 'light';
  static const String themeModeDark = 'dark';
  static const String themeModeSystem = 'system';

  static SharedPreferences? _preferences;

  // Singleton pattern
  PreferencesHelper._privateConstructor();
  static final PreferencesHelper instance = PreferencesHelper._privateConstructor();

  // Initialize SharedPreferences
  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // Get SharedPreferences instance
  SharedPreferences get preferences {
    if (_preferences == null) {
      throw Exception('PreferencesHelper not initialized. Call init() first.');
    }
    return _preferences!;
  }

  // Theme Mode Methods
  Future<bool> setThemeMode(String themeMode) async {
    return await preferences.setString(_keyThemeMode, themeMode);
  }

  String getThemeMode() {
    return preferences.getString(_keyThemeMode) ?? themeModeSystem;
  }

  Future<bool> clearThemeMode() async {
    return await preferences.remove(_keyThemeMode);
  }

  // Daily Reminder Methods
  Future<bool> setDailyReminder(bool enabled) async {
    return await preferences.setBool(_keyDailyReminder, enabled);
  }

  bool getDailyReminder() {
    return preferences.getBool(_keyDailyReminder) ?? false;
  }

  Future<bool> clearDailyReminder() async {
    return await preferences.remove(_keyDailyReminder);
  }

  // First Launch Methods
  Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    return await preferences.setBool(_keyFirstLaunch, isFirstLaunch);
  }

  bool isFirstLaunch() {
    return preferences.getBool(_keyFirstLaunch) ?? true;
  }

  Future<bool> clearFirstLaunch() async {
    return await preferences.remove(_keyFirstLaunch);
  }

  // Utility Methods
  Future<bool> clearAll() async {
    return await preferences.clear();
  }

  Set<String> getKeys() {
    return preferences.getKeys();
  }

  bool containsKey(String key) {
    return preferences.containsKey(key);
  }

  // Generic getter and setter methods
  Future<bool> setString(String key, String value) async {
    return await preferences.setString(key, value);
  }

  String? getString(String key, {String? defaultValue}) {
    return preferences.getString(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) async {
    return await preferences.setBool(key, value);
  }

  bool? getBool(String key, {bool? defaultValue}) {
    return preferences.getBool(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) async {
    return await preferences.setInt(key, value);
  }

  int? getInt(String key, {int? defaultValue}) {
    return preferences.getInt(key) ?? defaultValue;
  }

  Future<bool> setDouble(String key, double value) async {
    return await preferences.setDouble(key, value);
  }

  double? getDouble(String key, {double? defaultValue}) {
    return preferences.getDouble(key) ?? defaultValue;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await preferences.setStringList(key, value);
  }

  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return preferences.getStringList(key) ?? defaultValue;
  }

  Future<bool> remove(String key) async {
    return await preferences.remove(key);
  }
}