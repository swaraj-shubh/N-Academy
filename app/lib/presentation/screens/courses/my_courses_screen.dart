import 'package:flutter/material.dart';
import '../../../data/repositories/enrollment_repository.dart'; // FIXED PATH
import '../../../data/models/enrollment_model.dart'; // FIXED PATH
import '../../../core/theme/colors.dart'; // ADD THIS
import '../../../core/theme/text_styles.dart'; // ADD THIS

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  final EnrollmentRepository _enrollmentRepository = EnrollmentRepository();
  List<EnrollmentModel> _enrollments = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMyCourses();
  }

  Future<void> _loadMyCourses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final enrollments = await _enrollmentRepository.getMyCourses();
      setState(() {
        _enrollments = enrollments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMyCourses,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadMyCourses,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _enrollments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _enrollments.length,
                      itemBuilder: (context, index) {
                        final enrollment = _enrollments[index];
                        return MyCourseCard(enrollment: enrollment);
                      },
                    ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No courses enrolled',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            'Enroll in courses to see them here',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to courses
            },
            child: const Text('Browse Courses'),
          ),
        ],
      ),
    );
  }
}

class MyCourseCard extends StatelessWidget {
  final EnrollmentModel enrollment;

  const MyCourseCard({super.key, required this.enrollment});

  @override
  Widget build(BuildContext context) {
    final course = enrollment.course;
    if (course == null) return const SizedBox();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Title and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    course.title,
                    style: AppTextStyles.heading3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(
                    enrollment.status.toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: enrollment.status == 'active'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      '${enrollment.progress?['completionPercentage'] ?? 0}%',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (enrollment.progress?['completionPercentage'] ?? 0) / 100,
                  backgroundColor: Colors.grey[200],
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Continue learning
                },
                child: const Text('Continue Learning'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}