// data/repositories/teacher_repository.dart
// import 'dart:convert';
import '../data_sources/api_client.dart';
import '../models/course_model.dart';
import '../models/teacher_dashboard_model.dart';

class TeacherRepository {
  final ApiClient _apiClient = ApiClient();

  Future<TeacherDashboardModel> getTeacherDashboard() async {
    try {
      final response = await _apiClient.getTeacherDashboard();
      
      print('📊 Teacher Dashboard Response: ${response.data}'); // ← Add this
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return TeacherDashboardModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to load dashboard');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Teacher Dashboard Error: $e'); // ← Add this
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createCourse({
    required String title,
    required String description,
    required double price,
    String currency = 'INR',
  }) async {
    try {
      final response = await _apiClient.post('/courses', data: {
        'title': title,
        'description': description,
        'price': price,
        'currency': currency,
      });
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          return {
            'success': true,
            'course': CourseModel.fromJson(data['data']),
            'message': data['message'] ?? 'Course created successfully',
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Failed to create course',
          };
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}