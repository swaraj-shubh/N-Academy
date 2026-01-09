// data/models/auth_response.dart
import 'user_model.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing AuthResponse from: $json');
    
    try {
      // Extract accessToken
      final accessToken = json['accessToken'] as String?;
      if (accessToken == null) {
        throw Exception('Missing accessToken in response');
      }
      
      // Extract refreshToken
      final refreshToken = json['refreshToken'] as String?;
      if (refreshToken == null) {
        throw Exception('Missing refreshToken in response');
      }
      
      // Extract user from response (not from token!)
      final userJson = json['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw Exception('Missing user data in response');
      }
      
      final user = UserModel.fromJson(userJson);
      
      return AuthResponse(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user,
      );
    } catch (e) {
      print('❌ Error parsing AuthResponse: $e');
      rethrow;
    }
  }
}