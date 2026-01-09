// data/repositories/auth_repository.dart
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
    print('🔐 AuthRepository: Attempting login for $email');
    
    final response = await _apiClient.login(email, password);

    print('📡 AuthRepository: Response status: ${response.statusCode}');
    print('📡 AuthRepository: Response data: ${response.data}');
    
    if (response.statusCode == 200) {
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['success'] != true) {
        throw Exception('Login failed: ${responseData['message'] ?? 'Unknown error'}');
      }
      
      final data = responseData['data'] as Map<String, dynamic>;
      
      // Parse the complete AuthResponse from data (which now includes user)
      final auth = AuthResponse.fromJson(data);
      
      // Save tokens
      await _storage.write(
        key: AppConstants.accessTokenKey,
        value: auth.accessToken,
      );
      await _storage.write(
        key: AppConstants.refreshTokenKey,
        value: auth.refreshToken,
      );
      
      // Save user data
      await _storage.write(
        key: AppConstants.userDataKey,
        value: jsonEncode(auth.user.toJson()),
      );
      
      print('✅ AuthRepository: Login successful for ${auth.user.email}');
      
      return auth;
    } else {
      throw Exception('Login failed with status ${response.statusCode}');
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
        final responseData = response.data as Map<String, dynamic>;
        
        if (responseData['success'] != true) {
          throw Exception('Registration failed: ${responseData['message'] ?? 'Unknown error'}');
        }
        
        final data = responseData['data'];
        if (data is Map<String, dynamic>) {
          return UserModel.fromJson(data);
        } else {
          // If data is just the user object directly
          return UserModel.fromJson(responseData['data'] as Map<String, dynamic>);
        }
      } else {
        throw Exception('Registration failed with status ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Try to call backend logout
      await _apiClient.post(
        AppConstants.logoutEndpoint,
        data: {},
      );
    } catch (e) {
      // Even if backend logout fails, still clear local storage
      print('Backend logout failed: $e');
    } finally {
      // Always clear local storage
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
      print('⚠️ getStoredUser error: $e');
      return null;
    }
  }
}