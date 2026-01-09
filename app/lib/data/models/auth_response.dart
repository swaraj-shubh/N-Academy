// import 'package:n_academy/data/models/user_model.dart'; --- IGNORE ---
import '../models/user_model.dart';
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
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: UserModel.fromJson(json['user']),
    );
  }
}