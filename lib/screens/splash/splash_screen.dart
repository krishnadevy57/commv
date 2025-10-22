import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async{
      bool isLogin = await authController.checkLoginStatus(); // Check session and route accordingly
      if(isLogin){
        Get.offAllNamed(AppRoutes.landing);
      }else{
        Get.offAllNamed(AppRoutes.login);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [

          Container(
            color: Colors.black.withOpacity(0.6), // Optional overlay for better contrast
            child: Center(
              child: Image.asset(
                "assets/images/commv_logo.jpg",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
