import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
   OtpScreen({super.key});
  final authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final String phone = Get.arguments ?? '';

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'OTP Verification',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.appBarTheme.titleTextStyle?.color ??
                  colorScheme.onPrimary,
            ),
          ),
          centerTitle: true,
          backgroundColor:
          theme.appBarTheme.backgroundColor ?? colorScheme.surface,
          elevation: theme.appBarTheme.elevation ?? 1,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: colorScheme.primary),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/commv_logo.jpg', height: 80),
              const SizedBox(height: 48),

              // OTP input field
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                controller: authController.otpController.value,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  hintStyle: TextStyle(color: theme.hintColor),
                  border: const UnderlineInputBorder(),
                  errorText: authController.otpError.value,
                ),
              ),
              const SizedBox(height: 32),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () => authController.verifyOtp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
    );
  }
}
