import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/services/api_service.dart';
import '../../core/utils/device_utils.dart';
import '../auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                  final deviceId = await DeviceUtils.getDeviceId();

                  final res = await ApiService.dio.post(
                    "/api/auth/login",
                    data: {
                      "email": emailCtrl.text,
                      "password": passCtrl.text,
                      "deviceId": deviceId,
                    },
                  );

                  final token = res.data['data']['accessToken'];

                  await ref.read(authProvider.notifier).login(token, deviceId);

                  Navigator.pushReplacementNamed(context, "/home");
                } on DioException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.response?.data['message'] ?? "Login failed")),
                  );
                }
              },
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
