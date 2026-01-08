import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final res = await ApiService.dio.get("/api/dashboard/profile");
    setState(() => profile = res.data['data']);
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Email: ${profile!['email']}"),
            Text("Role: ${profile!['role']}"),
          ],
        ),
      ),
    );
  }
}
