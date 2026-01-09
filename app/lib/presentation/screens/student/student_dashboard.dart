// presentation/screens/student/student_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/repositories/student_repository.dart';
import '../../../data/models/student_dashboard_model.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final StudentRepository _studentRepository = StudentRepository();
  StudentDashboardModel? _dashboardData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _studentRepository.getStudentDashboard();
      setState(() {
        _dashboardData = data;
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
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDashboardData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_dashboardData == null || _dashboardData!.courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              'No Courses Enrolled',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 10),
            const Text(
              'Browse and enroll in courses to get started',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to courses screen
                // You'll need to handle this navigation
              },
              child: const Text('Browse Courses'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Learning',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Enrolled Courses',
                          value: _dashboardData!.totalEnrolledCourses.toString(),
                          icon: Icons.library_books_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total Spent',
                          value: '₹${_calculateTotalSpent()}',
                          icon: Icons.currency_rupee_outlined,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Courses List
          Text(
            'My Courses (${_dashboardData!.totalEnrolledCourses})',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 12),
          
          ..._dashboardData!.courses.map((enrollment) {
            return _buildEnrollmentCard(enrollment);
          }).toList(),
        ],
      ),
    );
  }

  double _calculateTotalSpent() {
    if (_dashboardData == null) return 0.0;
    double total = 0;
    for (var enrollment in _dashboardData!.courses) {
      final price = enrollment.purchase['pricePaid'] ?? enrollment.course.price;
      total += (price is int ? price.toDouble() : price) ?? 0;
    }
    return total;
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentCard(StudentEnrollmentData enrollment) {
    final progress = enrollment.progress['completionPercentage'] ?? 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enrollment.course.title,
                        style: AppTextStyles.heading3,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By ${enrollment.course.teacher != null ? enrollment.course.teacher!.email.split('@')[0] : "Unknown Teacher"}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    enrollment.status.toUpperCase(),
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: enrollment.status == 'active'
                      ? AppColors.secondary.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Purchase Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Purchased On',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        enrollment.createdAt.toString().split(' ')[0],
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Price Paid',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        '₹${enrollment.purchase['pricePaid'] ?? enrollment.course.price}',
                        style: AppTextStyles.heading4.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Progress Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$progress%',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppColors.lightGrey,
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
                const SizedBox(height: 4),
                Text(
                  '${enrollment.progress['completedVideos']?.length ?? 0} videos completed',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Continue learning - navigate to course content
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Continue Learning'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}