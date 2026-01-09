import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/course_repository.dart'; // FIXED PATH
import '../../../data/models/course_model.dart'; // FIXED PATH
import 'course_detail_screen.dart';
import '../../../core/theme/colors.dart'; // ADD THIS
import '../../../core/theme/text_styles.dart'; // ADD THIS

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  List<CourseModel> _courses = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final courses = await _courseRepository.getCourses();
      setState(() {
        _courses = courses;
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
                        onPressed: _loadCourses,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _courses.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        final course = _courses[index];
                        return CourseCard(course: course);
                      },
                    ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.library_books_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No courses available',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new courses',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(course: course),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Title
              Text(
                course.title,
                style: AppTextStyles.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Course Description
              Text(
                course.description,
                style: AppTextStyles.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              
              // Course Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Teacher
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        course.teacherEmail.split('@')[0],
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  
                  // Price
                  Chip(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    label: Text(
                      '₹${course.price}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}