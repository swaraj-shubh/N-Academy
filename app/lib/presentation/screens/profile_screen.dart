import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User Info
                  Text(
                    user?.email.split('@')[0] ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    label: Text(
                      user?.role.toUpperCase() ?? 'STUDENT',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Account Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Information',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: user?.email ?? '',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: 'Role',
                    value: user?.role ?? 'student',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.calendar_today_outlined,
                    title: 'Member Since',
                    value: user?.createdAt.toString().split(' ')[0] ?? 'N/A',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Edit profile
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGrey,
                      foregroundColor: AppColors.textDark,
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Change password
                    },
                    icon: const Icon(Icons.lock_outline),
                    label: const Text('Change Password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGrey,
                      foregroundColor: AppColors.textDark,
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirmed == true) {
                        await authProvider.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger.withOpacity(0.1),
                      foregroundColor: AppColors.danger,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.bodyMedium),
        subtitle: Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}