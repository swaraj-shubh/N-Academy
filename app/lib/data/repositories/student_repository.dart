// data/repositories/student_repository.dart
import '../data_sources/api_client.dart';
import '../models/student_dashboard_model.dart';

class StudentRepository {
  final ApiClient _apiClient = ApiClient();

  Future<StudentDashboardModel> getStudentDashboard() async {
    try {
      final response = await _apiClient.getStudentDashboard();
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return StudentDashboardModel.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to load dashboard');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}