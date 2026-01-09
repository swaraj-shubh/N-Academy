import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository = AuthRepository();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _loadStoredUser();
  }

  Future<void> _loadStoredUser() async {
    _user = await authRepository.getStoredUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await authRepository.login(email, password);
      _user = response.user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String email, 
    String password, 
    String role
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await authRepository.register(email, password, role);
      _user = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    try {
      _user = await authRepository.getProfile();
      notifyListeners();
    } catch (e) {
      // Silently fail for profile refresh
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}