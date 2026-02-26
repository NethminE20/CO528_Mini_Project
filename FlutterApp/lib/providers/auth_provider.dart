import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;

  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    final storedUser = prefs.getString('user');

    if (storedToken != null && storedUser != null) {
      _token = storedToken;
      try {
        _user = jsonDecode(storedUser);
      } catch (_) {}
      ApiService.setToken(_token);
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final res = await ApiService.loginUser({
      'email': email,
      'password': password,
    });

    _token = res['token'];
    _user = res['user'];
    ApiService.setToken(_token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('user', jsonEncode(_user));
    notifyListeners();
  }

  Future<void> register(Map<String, dynamic> data) async {
    await ApiService.registerUser(data);
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    ApiService.setToken(null);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    notifyListeners();
  }
}
