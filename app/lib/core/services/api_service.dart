import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<void> setAuthHeaders(String token, String deviceId) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['x-device-id'] = deviceId;
  }

  static void clearAuthHeaders() {
    dio.options.headers.remove('Authorization');
    dio.options.headers.remove('x-device-id');
  }
}
