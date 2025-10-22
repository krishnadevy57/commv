import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
   SignUpScreen({super.key});
  final controller = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String mobileNumber = Get.arguments ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor ?? colorScheme.surface,
        elevation: 1,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, size: 16, color: colorScheme.primary),
          label: Text('', style: TextStyle(color: colorScheme.primary)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() => Column(
          children: [
            Image.asset('assets/images/commv_logo.jpg', height: 80),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mobile
                  Row(
                    children: [
                      Text('Mobile No: ', style: theme.textTheme.bodyLarge),
                      Text(
                        mobileNumber,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text('Change',
                            style: TextStyle(color: colorScheme.error)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // First Name
                  TextField(
                    controller: controller.firstNameController.value,
                    decoration: InputDecoration(
                      hintText: 'Enter First Name',
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Last Name
                  TextField(
                    controller: controller.lastNameController.value,
                    decoration: InputDecoration(
                      hintText: 'Enter Last Name',
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Email
                  TextField(
                    controller: controller.emailController.value,
                    decoration: InputDecoration(
                      hintText: 'Enter Email Id',
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Usage Type
                  Text(
                    'Select Usage Type',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Container(
                  //   height: 120,
                  //   decoration: BoxDecoration(
                  //     color: colorScheme.surfaceContainerHighest,
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: CupertinoPicker(
                  //     scrollController: FixedExtentScrollController(
                  //       initialItem: controller.selectedUsageIndex.value,
                  //     ),
                  //     itemExtent: 32.0,
                  //     onSelectedItemChanged: (int index) {
                  //       controller.selectedUsageIndex.value = index;
                  //     },
                  //     children: AuthController.usageTypes
                  //         .map((type) => Center(
                  //       child: Text(
                  //         type,
                  //         style: theme.textTheme.bodyMedium,
                  //       ),
                  //     ))
                  //         .toList(),
                  //   ),
                  // ),
                  // const SizedBox(height: 24),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.updateProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                          color: Colors.white)
                          : const Text('UPDATE', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
