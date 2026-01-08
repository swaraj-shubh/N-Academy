import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/api_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  Future<void> login(String token, String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);

    await ApiService.setAuthHeaders(token, deviceId);
    state = true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    ApiService.clearAuthHeaders();
    state = false;
  }
}
