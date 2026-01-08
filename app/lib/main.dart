import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth/login/login_screen.dart';
import 'auth/register/register_screen.dart';
import 'dashboard/home/home_screen.dart';
import 'dashboard/profile/profile_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/login": (_) => const LoginScreen(),
        "/register": (_) => const RegisterScreen(),
        "/home": (_) => const HomeScreen(),
        "/profile": (_) => const ProfileScreen(),
      },
      initialRoute: "/login",
    );
  }
}
