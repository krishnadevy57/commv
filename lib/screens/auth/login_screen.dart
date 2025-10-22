import 'package:commv/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
  final AuthController authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Login',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.appBarTheme.titleTextStyle?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: theme.appBarTheme.elevation ?? 1,
          iconTheme: theme.appBarTheme.iconTheme,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/commv_logo.jpg', height: 80),
              const SizedBox(height: 48),

              // Phone input with flag
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                      color: theme.cardColor,
                    ),
                    child: Image.asset(
                      'assets/images/flag_india.png',
                      width: 40,
                      height: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: authController.phoneController.value,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Enter Mobile Number',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                        border: const UnderlineInputBorder(),
                        errorText: authController.phoneError.value,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Continue button with loading
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () {
                    authController.loginWithPhone();
                  },
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
