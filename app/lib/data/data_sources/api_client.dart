import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';

class ApiClient {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final CookieJar _cookieJar = CookieJar();
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() => _instance;
  
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Add cookie manager
    _dio.interceptors.add(CookieManager(_cookieJar));
    
    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onError: _onError,
    ));
  }

  Future<void> _onRequest(
    RequestOptions options, 
    RequestInterceptorHandler handler
  ) async {
    // Add device ID
    String deviceId = await _getOrCreateDeviceId();
    options.headers['x-device-id'] = deviceId;
    
    // Add access token if available
    final accessToken = await _storage.read(key: AppConstants.accessTokenKey);
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    
    handler.next(options);
  }

  Future<void> _onError(
    DioException error, 
    ErrorInterceptorHandler handler
  ) async {
    // Handle 401 Unauthorized
    if (error.response?.statusCode == 401) {
      // Try to refresh token
      final refreshToken = await _storage.read(
        key: AppConstants.refreshTokenKey
      );
      
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final response = await _dio.post(
            AppConstants.refreshEndpoint,
            data: {'refreshToken': refreshToken},
          );
          
          if (response.statusCode == 200) {
            final data = response.data;
            if (data['success'] == true) {
              final newAccessToken = data['accessToken'];
              await _storage.write(
                key: AppConstants.accessTokenKey,
                value: newAccessToken,
              );
              
              // Retry the original request
              final request = error.requestOptions;
              request.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryResponse = await _dio.fetch(request);
              return handler.resolve(retryResponse);
            }
          }
        } catch (e) {
          // Refresh failed, logout
          await logout();
          // Navigate to login screen
          // You might want to use a global navigator key here
        }
      } else {
        await logout();
      }
    }
    
    handler.next(error);
  }

  Future<String> _getOrCreateDeviceId() async {
    String? deviceId = await _storage.read(key: AppConstants.deviceIdKey);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      await _storage.write(key: AppConstants.deviceIdKey, value: deviceId);
    }
    return deviceId;
  }

  Future<void> logout() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
    await _storage.delete(key: AppConstants.userDataKey);
    // Clear cookies
    _cookieJar.deleteAll();
  }

  // API Methods
  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  Future<Response> get(String path) async {
    return _dio.get(path);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }

  // Auth Methods
  Future<Response> login(String email, String password) async {
    return post(
      AppConstants.loginEndpoint,
      data: {
        'email': email,
        'password': password,
        'deviceId': await _getOrCreateDeviceId(),
      },
    );
  }

  Future<Response> register(
    String email, 
    String password, 
    String role
  ) async {
    return post(
      AppConstants.registerEndpoint,
      data: {
        'email': email,
        'password': password,
        'role': role,
      },
    );
  }

  Future<Response> getProfile() async {
    return get(AppConstants.profileEndpoint);
  }

  Future<Response> getCourses() async {
    return get(AppConstants.coursesEndpoint);
  }

  Future<Response> enrollCourse(String courseId) async {
    return post('${AppConstants.enrollEndpoint}/$courseId');
  }

  Future<Response> getMyCourses() async {
    return get(AppConstants.myCoursesEndpoint);
  }
}