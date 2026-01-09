import '../data_sources/api_client.dart';
import '../models/enrollment_model.dart';

class EnrollmentRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<EnrollmentModel>> getMyCourses() async {
    try {
      final response = await _apiClient.getMyCourses();
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> enrollmentsData = data['data'] ?? [];
          return enrollmentsData.map((json) => EnrollmentModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load enrollments');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<EnrollmentModel> enrollCourse(String courseId) async {
    try {
      final response = await _apiClient.enrollCourse(courseId);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          return EnrollmentModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to enroll');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}