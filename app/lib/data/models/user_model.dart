// data/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('👤 Parsing UserModel from: $json');
    
    try {
      // Handle both '_id' and 'id' fields
      final id = json['_id']?.toString() ?? json['id']?.toString();
      if (id == null) {
        throw Exception('Missing user id');
      }
      
      final email = json['email'] as String?;
      if (email == null) {
        throw Exception('Missing user email');
      }
      
      final role = json['role'] as String? ?? 'student';
      
      // Parse dates - handle different formats
      DateTime? createdAt;
      try {
        final createdAtStr = json['createdAt'] as String?;
        if (createdAtStr != null) {
          createdAt = DateTime.parse(createdAtStr);
        }
      } catch (e) {
        print('⚠️ Could not parse createdAt: $e');
      }
      
      DateTime? updatedAt;
      try {
        final updatedAtStr = json['updatedAt'] as String?;
        if (updatedAtStr != null) {
          updatedAt = DateTime.parse(updatedAtStr);
        }
      } catch (e) {
        print('⚠️ Could not parse updatedAt: $e');
      }
      
      // Use current time if dates are missing
      final now = DateTime.now();
      
      return UserModel(
        id: id,
        email: email,
        role: role,
        createdAt: createdAt ?? now,
        updatedAt: updatedAt ?? now,
      );
    } catch (e) {
      print('❌ Error parsing UserModel: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';
  bool get isAdmin => role == 'admin';
}