import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/course_model.dart';
import '../../../data/repositories/enrollment_repository.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final EnrollmentRepository _enrollmentRepository = EnrollmentRepository();
  bool _isEnrolling = false;

  Future<void> _enrollInCourse() async {
    setState(() {
      _isEnrolling = true;
    });

    try {
      await _enrollmentRepository.enrollCourse(widget.course.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully enrolled in course!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back or to my courses
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to enroll: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEnrolling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image/Placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: AppColors.primary.withOpacity(0.1),
              child: const Icon(
                Icons.school,
                size: 100,
                color: AppColors.primary,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Title
                  Text(
                    widget.course.title,
                    style: AppTextStyles.heading1,
                  ),
                  const SizedBox(height: 8),
                  
                  // Teacher Info
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: AppColors.darkGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.course.teacherEmail,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Price
                  Chip(
                    label: Text(
                      '₹${widget.course.price}',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  Text(
                    'Description',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.course.description,
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  
                  // Enroll Button
                  if (user?.isStudent ?? false)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isEnrolling ? null : _enrollInCourse,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: _isEnrolling
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Enroll Now',
                                style: AppTextStyles.button,
                              ),
                      ),
                    ),
                  
                  if (user?.isTeacher ?? false)
                    const Text(
                      'Teachers cannot enroll in other courses',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}