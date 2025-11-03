import 'dart:convert';
import 'dart:io';

import 'package:commv/services/storage_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_verify_response_model.dart';
import '../models/otp_response_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  static AuthController get instance {
    try {
      return Get.find<AuthController>();
    } catch (e) {
      return Get.put(AuthController());
    }
  }

  var userProfile = User().obs;

  final phoneController = TextEditingController().obs;
  final otpController = TextEditingController().obs;

  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final selectedUsageIndex = 2.obs;

  final phoneError = RxnString();
  final otpError = RxnString();
  final isLoading = false.obs;
  OtpResponseModel? otpResponseModel;
  final ApiService _userService = ApiService();

  void loginWithPhone() async {
    final phone = phoneController.value.text.trim();

    if (phone.isEmpty || phone.length != 10) {
      phoneError.value = 'Enter a valid 10-digit phone number';
      return;
    }

    phoneError.value = null;
    isLoading.value = true;

    try {
      final response = await _userService.sendOtp(phone);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        otpResponseModel = OtpResponseModel.fromJson(data);

        // Use the model fields for logic or UI
        Get.snackbar(
            "Success", "${otpResponseModel?.message}  ${otpResponseModel?.otp}",
            backgroundColor: Colors.green, colorText: Colors.white);
        // You can pass the OTP to OTP screen via arguments if needed
        Get.toNamed(
          AppRoutes.otp,
        );
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Error", error['message'] ?? "Failed to send OTP",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        // For Android
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id; // Hardware ID or device ID
      } else if (Platform.isIOS) {
        // For iOS
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor; // Unique ID for the device
      }
    } catch (e) {
      print("Error getting device ID: $e");
    }
    return null;
  }

  Future<bool> checkLoginStatus() async {
    var prefs = StorageService.instance;
    if (prefs.isLoggedIn) {
      getUserProfile();
      return true;
    } else {
      return false;
    }
  }


  void getUserProfile() async {
    var prefs = StorageService.instance;
    userProfile.value = prefs.userProfile??User();
  }

  Future<void> verifyOtp() async {
    final otp = otpController.value.text.trim();
    final phone = phoneController.value.text.trim();

    if (otp.length != 6) {
      otpError.value = 'OTP must be 6 digits';
      return;
    }

    isLoading.value = true;
    otpError.value = null;

    // Replace with your actual FCM/device token retrieval logic
    var deviceToken =  StorageService.instance.deviceToken;

    try {
      final response = await _userService.loginVerifyOtp(
          otp: otp,
          userphoneNo: phone,
          deviceToken: deviceToken ?? "");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final otpResponse = LoginVerifyModel.fromJson(data);

        otpResponse.user?.id;
        // Use the model fields for logic or UI
        Get.snackbar("Success", "Successfully verified",
            backgroundColor: Colors.green, colorText: Colors.white);
        StorageService.instance.setLoggedIn(true);
        StorageService.instance.saveToken(otpResponse.token ?? "");
        StorageService.instance.saveUserProfile(otpResponse.user);
        getUserProfile();
        // You can pass the OTP to OTP screen via arguments if needed
        if ((otpResponseModel?.action ?? "") == "login") {
          Get.offAllNamed(AppRoutes.landing);
        } else {
          Get.offAndToNamed(
            AppRoutes.signup,
          );
        }

      } else {
        otpController.value.text = "";
        final error = jsonDecode(response.body);
        Get.snackbar("Error", error['message'] ?? "Failed to verify OTP",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      otpError.value = 'Something went wrong';
      otpController.value.text = "";
    } finally {
      isLoading.value = false;
    }
  }

  // void registerUser(String mobile) async {
  //   final firstName = firstNameController.value.text.trim();
  //   final lastName = lastNameController.value.text.trim();
  //   final email = emailController.value.text.trim();
  //   final usage = usageTypes[selectedUsageIndex.value];
  //
  //   if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
  //     Get.snackbar("Error", "Please fill all fields",
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //     return;
  //   }
  //
  //   isLoading.value = true;
  //
  //   try {
  //     // TODO: Replace with real API call
  //     await Future.delayed(const Duration(seconds: 2));
  //
  //     Get.offAllNamed(AppRoutes.landing);
  //   } catch (e) {
  //     Get.snackbar("Error", "Registration failed: ${e.toString()}",
  //         backgroundColor: Colors.red, colorText: Colors.white);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  void updateProfile() async {
    final firstName = firstNameController.value.text.trim();
    final lastName = lastNameController.value.text.trim();
    final email = emailController.value.text.trim();

    if (firstName.isEmpty || email.isEmpty) {
      Get.snackbar("Error", "Please fill all fields",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    isLoading.value = true;

    try {
      final response = await _userService.updateProfile(
          userFirstName: firstName,
          userLastName: lastName,
          userEmail: email);

      if (response.statusCode == 200) {
        try{


        final data = jsonDecode(response.body);
        final otpResponse = LoginVerifyModel.fromJson(data);
        final storageService = await StorageService.instance; // Get stored token
        var token = storageService.token;
        otpResponse.token = token;
        otpResponse.user?.id;
        // Use the model fields for logic or UI
        Get.snackbar("Success", "Successfully verified",
            backgroundColor: Colors.green, colorText: Colors.white);

        // You can pass the OTP to OTP screen via arguments if needed

          StorageService.instance.setLoggedIn(true);
          StorageService.instance.saveToken(otpResponse.token ?? "");
          StorageService.instance.saveUserProfile(otpResponse.user);
        getUserProfile();
          Get.offAllNamed(AppRoutes.landing);
        }catch(e){
          print(e);
        }

      } else {
        // otpController.value.text = "";
        final error = jsonDecode(response.body);
        Get.snackbar("Error", error['error'] ?? "Failed to verify OTP",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      otpError.value = 'Something went wrong';
      otpController.value.text = "";
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
        Get.offAllNamed(AppRoutes.login);
  }


  // static List<String> usageTypes = [
  //   'Business Usage',
  //   'Personal Usage',
  //   'House Shifting Usage',
  //   'Other',
  // ];

  @override
  void onClose() {
    super.onClose();
  }
}
