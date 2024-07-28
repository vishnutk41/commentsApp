import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserEmailProvider with ChangeNotifier {
  String? _userEmail;

  String? get userEmail => _userEmail;

  Future<void> loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('userEmail');
    notifyListeners();
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    _userEmail = email;
    notifyListeners();
  }

  Future<void> clearUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    _userEmail = null;
    notifyListeners();
  }
}
