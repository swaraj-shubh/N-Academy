// data/models/dashboard_course_model.dart
class DashboardCourseModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final DateTime createdAt;
  final DashboardTeacherModel? teacher;
  final String? status;
  final DateTime? updatedAt;

  DashboardCourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.createdAt,
    this.teacher,
    this.status,
    this.updatedAt,
  });

  factory DashboardCourseModel.fromJson(Map<String, dynamic> json) {
    return DashboardCourseModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'INR',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      teacher: json['teacherId'] != null && json['teacherId'] is Map
          ? DashboardTeacherModel.fromJson(json['teacherId'])
          : null,
      status: json['status']?.toString(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }
}

class DashboardTeacherModel {
  final String id;
  final String email;

  DashboardTeacherModel({
    required this.id,
    required this.email,
  });

  factory DashboardTeacherModel.fromJson(Map<String, dynamic> json) {
    return DashboardTeacherModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}