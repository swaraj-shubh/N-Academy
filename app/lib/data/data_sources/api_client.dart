// lib/data/data_sources/api_client.dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/navigation_service.dart';

class ApiClient {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  // final CookieJar _cookieJar = CookieJar();
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
    // _dio.interceptors.add(CookieManager(_cookieJar));
    
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
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      try {
        // Call refresh WITHOUT sending refreshToken manually
        final response = await _dio.post(AppConstants.refreshEndpoint);

        if (response.statusCode == 200 &&
            response.data['success'] == true) {
          final newAccessToken =
              response.data['data']['accessToken'];

          await _storage.write(
            key: AppConstants.accessTokenKey,
            value: newAccessToken,
          );

          // Retry original request
          final request = error.requestOptions;
          request.headers['Authorization'] =
              'Bearer $newAccessToken';

          final retryResponse = await _dio.fetch(request);
          return handler.resolve(retryResponse);
        }
      } catch (_) {
        await logout();
        NavigationService.navigateReplacement(AppRoutes.login);
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
    // _cookieJar.deleteAll();
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

  Future<Response> login(String email, String password) async {
    print('🌐 API Client: Sending login request to ${AppConstants.loginEndpoint}');
    
    try {
      final response = await post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
          'deviceId': await _getOrCreateDeviceId(),
        },
      );
      
      print('✅ API Client: Login response received');
      print('   Status: ${response.statusCode}');
      print('   Headers: ${response.headers}');
      print('   Data: ${response.data}');
      print('   Data Type: ${response.data.runtimeType}');
      
      return response;
    } catch (e) {
      print('❌ API Client: Login request failed: $e');
      rethrow;
    }
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