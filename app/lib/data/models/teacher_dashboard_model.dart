// data/models/teacher_dashboard_model.dart
import 'dashboard_course_model.dart'; // Add this import

class TeacherDashboardModel {
  final int totalCourses;
  final List<TeacherCourseData> courses;

  TeacherDashboardModel({
    required this.totalCourses,
    required this.courses,
  });

  factory TeacherDashboardModel.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardModel(
      totalCourses: json['totalCourses'] ?? 0,
      courses: (json['courses'] as List<dynamic>?)
              ?.map((course) => TeacherCourseData.fromJson(course))
              .toList() ??
          [],
    );
  }
}

class TeacherCourseData {
  final DashboardCourseModel course; // Changed from CourseModel to DashboardCourseModel
  final int totalStudents;
  final List<TeacherEnrollmentData> students;

  TeacherCourseData({
    required this.course,
    required this.totalStudents,
    required this.students,
  });

  factory TeacherCourseData.fromJson(Map<String, dynamic> json) {
    return TeacherCourseData(
      course: DashboardCourseModel.fromJson(json['course'] ?? {}), // Updated
      totalStudents: json['totalStudents'] ?? 0,
      students: (json['students'] as List<dynamic>?)
              ?.map((student) => TeacherEnrollmentData.fromJson(student))
              .toList() ??
          [],
    );
  }
}

class TeacherEnrollmentData {
  final String id;
  final Map<String, dynamic> purchase;
  final Map<String, dynamic> progress;
  final StudentModel student;
  final String courseId;
  final DateTime createdAt;

  TeacherEnrollmentData({
    required this.id,
    required this.purchase,
    required this.progress,
    required this.student,
    required this.courseId,
    required this.createdAt,
  });

  factory TeacherEnrollmentData.fromJson(Map<String, dynamic> json) {
    return TeacherEnrollmentData(
      id: json['_id'] ?? json['id'],
      purchase: json['purchase'] ?? {},
      progress: json['progress'] ?? {},
      student: StudentModel.fromJson(json['studentId']),
      courseId: json['courseId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class StudentModel {
  final String id;
  final String email;
  final DateTime createdAt;

  StudentModel({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? json['id'],
      email: json['email'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}