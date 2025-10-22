import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class UpdateProfileScreen extends StatelessWidget {
  final AuthController authController = AuthController.instance;

  UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authController.userProfile.value;

    // Pre-fill controllers if not already set
    authController.firstNameController.value.text = user.username ?? '';
    authController.phoneController.value.text = user.userphoneNo ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: authController.firstNameController.value,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: authController.lastNameController.value,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: authController.phoneController.value,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
              enabled: false, // Usually mobile is not editable
            ),
            const SizedBox(height: 32),
            Obx(() => ElevatedButton(
              onPressed: authController.isLoading.value
                  ? null
                  : () => authController.updateProfile(),
              child: authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            )),
          ],
        ),
      ),
    );
  }
}