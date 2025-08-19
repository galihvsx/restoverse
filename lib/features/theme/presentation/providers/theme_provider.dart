import 'package:dcresto/core/preferences/preferences_helper.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final PreferencesHelper _prefs;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider({required PreferencesHelper preferencesHelper})
    : _prefs = preferencesHelper {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final stored = _prefs.getThemeMode();
    switch (stored) {
      case PreferencesHelper.themeModeLight:
        _themeMode = ThemeMode.light;
        break;
      case PreferencesHelper.themeModeDark:
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  void setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _prefs.setThemeMode(_themeMode.name);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
