import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final AuthController authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              color: scaffoldBg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name: ${authController.userProfile.value.username ?? ""}",
                        style: textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: colorScheme.primary),
                        onPressed: () {
                          // Get.to(() => update.UpdateProfileScreen());
                        },
                        tooltip: "Edit Profile",
                      ),
                    ],
                  ),                   SizedBox(height: 4),
                  Text("Email :${authController.userProfile.value.useremail??""}", style: textTheme.bodySmall),
                   SizedBox(height: 8),
                  Text("Mobile: ${authController.userProfile.value.userphoneNo??""}", style: textTheme.bodySmall),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Verify Email ID",
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ),
                  // const SizedBox(height: 12),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: colorScheme.primary.withOpacity(0.08),
                  //     foregroundColor: colorScheme.primary,
                  //   ),
                  //   child: const Text("Add GST Details"),
                  // ),
                ],
              ),
            ),

            const Divider(height: 0),

            // Saved Addresses
            _buildSectionTile(context, "Saved Addresses", Icons.favorite_border),

            // Benefits
            _buildSectionHeader(context, "Benefits"),
            _buildSectionTile(context, "Commv Rewards", Icons.star_border, trailing: const Text("0")),
            // _buildSectionTile(
            //   context,
            //   "Refer and earn ₹200",
            //   Icons.card_giftcard,
            //   trailing: TextButton(
            //     onPressed: () {},
            //     child: Text("Invite", style: TextStyle(color: colorScheme.primary)),
            //   ),
            // ),

            // Support & Legal
            _buildSectionHeader(context, "Support & Legal"),
            _buildSectionTile(context, "Help & Support", Icons.help_outline),
            _buildSectionTile(context, "Terms and Conditions", Icons.article_outlined),

            // Settings
            _buildSectionHeader(context, "Settings"),
            // _buildSectionTile(context, "Choose Language", Icons.language),
            _buildSectionTile(
              context,
              "Logout",
              Icons.logout,
              trailing: null,
              onTap: () {
                authController.logout();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6) ?? Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSectionTile(
      BuildContext context,
      String title,
      IconData icon, {
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title, style: textTheme.bodyLarge),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}