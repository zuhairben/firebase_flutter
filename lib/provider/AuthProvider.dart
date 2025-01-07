import 'package:flutter/material.dart';
import 'package:firebase_flutter/auth/AuthService.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String _userRole = '';
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String get userRole => _userRole;

  /// Handles user registration
  Future<String?> register({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _authService.registration(
      email: email,
      password: password,
      role: role,
    );
    if (response == 'Success') {
      _isAuthenticated = true;
      _userRole = role;
      notifyListeners();
    }
    return response;
  }

  /// Handles user login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final response = await _authService.login(
      email: email,
      password: password,
    );
    if (response == 'Success') {
      _isAuthenticated = true;
      _userRole = await _authService.getUserRole();
      notifyListeners();
    }
    return response;
  }

  /// Handles Google Sign-In
  Future<void> loginWithGoogle() async {
    await _authService.signInWithGoogle();
    _isAuthenticated = true;
    _userRole = await _authService.getUserRole();
    notifyListeners();
  }

  /// Logs out the user
  Future<void> logout() async {
    _isAuthenticated = false;
    _userRole = '';
    notifyListeners();
  }

  /// Gets the user role
  Future<String> fetchUserRole() async {
    _userRole = await _authService.getUserRole();
    notifyListeners();
    return _userRole;
  }
}
