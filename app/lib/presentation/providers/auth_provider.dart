// lib/presentation/providers/auth_provider.dart
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
    print('🔄 AuthProvider created');
    _loadStoredUser();
  }

  Future<void> _loadStoredUser() async {
    print('📱 AuthProvider: Loading stored user...');
    try {
      _user = await authRepository.getStoredUser();
      print(_user != null 
          ? '✅ AuthProvider: Loaded user: ${_user!.email}' 
          : '⚠️ AuthProvider: No stored user found');
      notifyListeners();
    } catch (e) {
      print('❌ AuthProvider: Error loading stored user: $e');
      _user = null;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    print('🔐 AuthProvider: Attempting login for $email');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await authRepository.login(email, password);
      _user = response.user;
      print('✅ AuthProvider: Login successful for ${_user!.email}');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ AuthProvider: Login failed: $e');
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
    print('📝 AuthProvider: Registering $email as $role');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await authRepository.register(email, password, role);
      _user = user;
      print('✅ AuthProvider: Registration successful');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ AuthProvider: Registration failed: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    print('🚪 AuthProvider: Logging out...');
    try {
      await authRepository.logout();
      print('✅ AuthProvider: Logout successful');
    } catch (e) {
      print('⚠️ AuthProvider: Logout error (continuing anyway): $e');
    } finally {
      // Always clear user state even if logout fails
      _user = null;
      notifyListeners();
      print('🔄 AuthProvider: User state cleared');
    }
  }

  Future<void> refreshProfile() async {
    print('🔄 AuthProvider: Refreshing profile...');
    try {
      _user = await authRepository.getProfile();
      print(_user != null 
          ? '✅ AuthProvider: Profile refreshed: ${_user!.email}' 
          : '⚠️ AuthProvider: Profile refresh returned null');
      notifyListeners();
    } catch (e) {
      print('❌ AuthProvider: Profile refresh failed: $e');
      // Don't set _user = null here - keep existing user if refresh fails
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  // Add this helper method for debugging
  void printState() {
    print('=== AuthProvider State ===');
    print('User: ${_user?.email ?? "null"}');
    print('Loading: $_isLoading');
    print('Error: $_errorMessage');
    print('=========================');
  }
}