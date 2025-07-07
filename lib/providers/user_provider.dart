import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _userName;
  String? _profileImagePath;

  String? get userName => _userName;
  String? get profileImagePath => _profileImagePath;

  UserProvider() {
    loadUser();
  }

  // Carga los datos del usuario desde la memoria del dispositivo al iniciar.
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('nombre');
    _profileImagePath = prefs.getString('profile_image_path');
    notifyListeners();
  }

  // CORRECCIÓN: Se ajusta la firma del método para que acepte parámetros nombrados.
  Future<void> updateUser({required String newName, String? newImagePath}) async {
    final prefs = await SharedPreferences.getInstance();

    _userName = newName;
    await prefs.setString('nombre', newName);

    if (newImagePath != null) {
      _profileImagePath = newImagePath;
      await prefs.setString('profile_image_path', newImagePath);
    }

    notifyListeners();
  }
}
