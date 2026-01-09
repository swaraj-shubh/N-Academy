import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data_sources/api_client.dart';
import '../models/user_model.dart';
import '../models/auth_response.dart';
import '../../core/constants/app_constants.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiClient.login(email, password);
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final user = UserModel.fromJson(data['user'] ?? data);
        
        // Save tokens
        await _storage.write(
          key: AppConstants.accessTokenKey,
          value: data['accessToken'],
        );
        await _storage.write(
          key: AppConstants.refreshTokenKey,
          value: data['refreshToken'],
        );
        
        // Save user data
        await _storage.write(
          key: AppConstants.userDataKey,
          value: jsonEncode(user.toJson()),
        );
        
        return AuthResponse(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
          user: user,
        );
      } else {
        throw Exception('Login failed: ${response.data['message']}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> register(
    String email, 
    String password, 
    String role
  ) async {
    try {
      final response = await _apiClient.register(email, password, role);
      
      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['data']);
        return user;
      } else {
        throw Exception('Registration failed: ${response.data['message']}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(
        AppConstants.logoutEndpoint,
        data: {},
      );
    } finally {
      await _apiClient.logout();
    }
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.getProfile();
      
      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['data']);
        
        // Update stored user data
        await _storage.write(
          key: AppConstants.userDataKey,
          value: jsonEncode(user.toJson()),
        );
        
        return user;
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null;
  }

  Future<UserModel?> getStoredUser() async {
    try {
      final userData = await _storage.read(key: AppConstants.userDataKey);
      if (userData != null) {
        return UserModel.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}