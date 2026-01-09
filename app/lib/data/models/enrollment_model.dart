// import 'package:n_academy/data/models/course_model.dart'; --- IGNORE ---
import '../models/course_model.dart';
class EnrollmentModel {
  final String id;
  final String studentId;
  final String courseId;
  final String teacherId;
  final CourseModel? course;
  final Map<String, dynamic> purchase;
  final String status;
  final Map<String, dynamic>? progress;
  final DateTime createdAt;

  EnrollmentModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.teacherId,
    this.course,
    required this.purchase,
    required this.status,
    this.progress,
    required this.createdAt,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['_id'] ?? json['id'],
      studentId: json['studentId'],
      courseId: json['courseId'],
      teacherId: json['teacherId'],
      course: json['courseId'] is Map
          ? CourseModel.fromJson(json['courseId'])
          : null,
      purchase: json['purchase'] ?? {},
      status: json['status'] ?? 'active',
      progress: json['progress'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}