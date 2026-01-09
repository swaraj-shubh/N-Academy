// data/models/course_model.dart
class CourseModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String teacherId;
  final String teacherEmail;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.teacherId,
    required this.teacherEmail,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      currency: json['currency'] ?? 'INR',
      teacherId: json['teacherId'] is String 
          ? json['teacherId']
          : json['teacherId']['_id'],
      teacherEmail: json['teacherId'] is String 
          ? ''
          : json['teacherId']['email'] ?? '',
      status: json['status'] ?? 'published',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}