import 'dart:convert';
import '../data_sources/api_client.dart';
import '../models/course_model.dart';

class CourseRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await _apiClient.getCourses();
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> coursesData = data['data'] ?? [];
          return coursesData.map((json) => CourseModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load courses');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}