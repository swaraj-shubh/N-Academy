// data/models/student_dashboard_model.dart
import 'dashboard_course_model.dart'; // Add this import

class StudentDashboardModel {
  final int totalEnrolledCourses;
  final List<StudentEnrollmentData> courses;

  StudentDashboardModel({
    required this.totalEnrolledCourses,
    required this.courses,
  });

  factory StudentDashboardModel.fromJson(Map<String, dynamic> json) {
    return StudentDashboardModel(
      totalEnrolledCourses: json['totalEnrolledCourses'] ?? 0,
      courses: (json['courses'] as List<dynamic>?)
              ?.map((course) => StudentEnrollmentData.fromJson(course))
              .toList() ??
          [],
    );
  }
}

class StudentEnrollmentData {
  final String id;
  final Map<String, dynamic> purchase;
  final Map<String, dynamic> progress;
  final DashboardCourseModel course; // Changed from CourseModel to DashboardCourseModel
  final String status;
  final DateTime createdAt;

  StudentEnrollmentData({
    required this.id,
    required this.purchase,
    required this.progress,
    required this.course,
    required this.status,
    required this.createdAt,
  });

  factory StudentEnrollmentData.fromJson(Map<String, dynamic> json) {
    return StudentEnrollmentData(
      id: json['_id'] ?? json['id'],
      purchase: json['purchase'] ?? {},
      progress: json['progress'] ?? {},
      course: DashboardCourseModel.fromJson(json['courseId'] ?? {}), // Updated
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}