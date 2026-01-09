// presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
// import '../../core/utils/navigation_service.dart';
// import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          _buildProfileHeader(user),
          
          const SizedBox(height: 20),
          
          // Account Information
          _buildAccountInfo(user),
          
          const SizedBox(height: 20),
          
          // Settings - PASS CONTEXT HERE
          _buildSettingsSection(context),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserModel? user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.9),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: Center(
              child: Text(
                user?.email[0].toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // User Info
          Text(
            user?.email.split('@')[0] ?? 'User',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Chip(
            backgroundColor: Colors.white.withOpacity(0.2),
            label: Text(
              user?.role.toUpperCase() ?? 'STUDENT',
              style: const TextStyle(
                color: Color.fromARGB(255, 31, 27, 27),
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
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(UserModel? user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: 'Email',
            value: user?.email ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildInfoTile(
            icon: Icons.badge_outlined,
            title: 'Role',
            value: user?.role ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildInfoTile(
            icon: Icons.calendar_today_outlined,
            title: 'Member Since',
            value: user?.createdAt.toString().split(' ')[0] ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildInfoTile(
            icon: Icons.credit_card_outlined,
            title: 'Account Status',
            value: 'Active',
            valueColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    Color valueColor = AppColors.textDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ADD CONTEXT PARAMETER HERE
  Widget _buildSettingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          _buildSettingOption(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: () {
              // Edit profile
            },
          ),
          const SizedBox(height: 12),
          _buildSettingOption(
            icon: Icons.lock_outlined,
            title: 'Change Password',
            onTap: () {
              // Change password
            },
          ),
          const SizedBox(height: 12),
          _buildSettingOption(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              // Notification settings
            },
          ),
          const SizedBox(height: 12),
          _buildSettingOption(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            onTap: () {
              // Dark mode toggle
            },
          ),
          const SizedBox(height: 12),
          _buildSettingOption(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // Help & support
            },
          ),
          const SizedBox(height: 12),
          _buildSettingOption(
            icon: Icons.logout_outlined,
            title: 'Logout',
            color: AppColors.danger,
            onTap: () => _showLogoutDialog(context), // NOW CONTEXT IS AVAILABLE
          ),
        ],
      ),
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.textDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  // presentation/screens/profile_screen.dart (Updated logout section)
  Future<void> _showLogoutDialog(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        // Perform logout
        await authProvider.logout();
        
        // Close loading dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        
        // Navigate to login screen using direct navigation
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        // Close loading dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        
        // Show error but still navigate to login
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Logout completed locally'),
              backgroundColor: Colors.orange,
            ),
          );
          
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    }
  }
}