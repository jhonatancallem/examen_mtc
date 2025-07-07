import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  static const String _themePrefKey = 'theme_mode';

  ThemeMode get themeMode => _themeMode;

  // Al iniciar, carga la preferencia de tema guardada.
  ThemeProvider() {
    _loadTheme();
  }

  // Carga el tema desde la memoria del dispositivo.
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Lee la preferencia; si no existe, usa el modo claro por defecto.
    final themeIndex = prefs.getInt(_themePrefKey) ?? ThemeMode.light.index;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  // Cambia el tema y guarda la nueva preferencia.
  void setTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefKey, _themeMode.index);
    // Notifica a los widgets que escuchan para que se redibujen.
    notifyListeners();
  }
}
