import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import './main_navigation_screen.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/colors.dart';
// import timeout
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a small delay before starting initialization
    Future.delayed(const Duration(milliseconds: 500), () {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    print('🚀 Splash: Starting...');
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // First, wait for _loadStoredUser to complete
    await Future.delayed(const Duration(milliseconds: 500));
    
    print('Splash: Local user check - ${authProvider.user?.email ?? "NULL"}');
    
    // If we have a user locally, go to main immediately
    if (authProvider.user != null) {
      print('✅ Splash: User exists locally, going to main');
      _navigateToMain();
      return;
    }
    
    // If no local user, try to refresh (network call)
    print('🔄 Splash: Trying refreshProfile...');
    try {
      await authProvider.refreshProfile().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('⏰ Splash: refreshProfile timeout');
          throw TimeoutException('refreshProfile timeout');
        },
      );
      
      if (authProvider.user != null) {
        print('✅ Splash: refreshProfile successful');
        _navigateToMain();
      } else {
        print('⚠️ Splash: refreshProfile returned null user');
        _navigateToLogin();
      }
    } catch (e) {
      print('❌ Splash: refreshProfile failed: $e');
      _navigateToLogin();
    }
  }

  void _navigateToMain() {
    if (!mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      print('➡️ Splash: Navigating to MainNavigationScreen');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    });
  }

  void _navigateToLogin() {
    if (!mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      print('➡️ Splash: Navigating to LoginScreen');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              AppConstants.appName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}