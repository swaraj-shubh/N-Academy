import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService.dio.post(
                    "/api/auth/register",
                    data: {
                      "email": emailCtrl.text,
                      "password": passCtrl.text,
                      "role": "student",
                    },
                  );

                  Navigator.pop(context);
                } on DioException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.response?.data['message'] ?? "Register failed")),
                  );
                }
              },
              child: const Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
