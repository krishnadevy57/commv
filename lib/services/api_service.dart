import 'dart:convert';
import 'dart:io';
import 'package:commv/services/storage_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../models/address_model.dart';
import '../models/vehicle_list_response.dart';

class ApiService {
  final String baseUrl = 'https://commv.skillupstream.com';

  /// 🔹 Helper function: handles 401 + logs request/response
  Future<http.Response> _sendRequest({
    required Future<http.Response> Function() requestFn,
    required String endpoint,
    String? body,
  }) async {
    try {
      print("📤 REQUEST → $endpoint");
      if (body != null) print("📦 Body: $body");

      final response = await requestFn();

      print("📥 RESPONSE [${response.statusCode}]");
      print("🔹 URL: $endpoint");
      print("🔹 Body: ${response.body}");

      // 🧾 Handle unauthorized case
      if (response.statusCode == 401) {
          print("🚨 Unauthorized detected → logging out...");
          await AuthController.instance.logout(); // clear token and session
        final storage = await StorageService.instance;
        await storage.clear(); // clear saved user/token
        // You can navigate to login here if context is available
      }

      return response;
    } catch (e) {
      print("❌ Exception during API call: $e");
      rethrow;
    }
  }

  Future<http.Response> sendOtp(String phoneNumber) async {
    final endpoint = '$baseUrl/api/user/usermobileno/send-otp';
    final url = Uri.parse(endpoint);
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({"userphoneNo": phoneNumber});

    return _sendRequest(
      requestFn: () => http.post(url, headers: headers, body: body),
      endpoint: endpoint,
      body: body,
    );
  }

  Future<http.Response> loginVerifyOtp({
    required String otp,
    required String userphoneNo,
    required String deviceToken,
  }) async {
    final endpoint = '$baseUrl/api/user/usermobilenootp/verify';
    final url = Uri.parse(endpoint);
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
    };

    final deviceDetails = await getDeviceDetails();
    final body = jsonEncode({
      "userphoneNo": userphoneNo,
      "otp": otp,
      "deviceId": deviceDetails['deviceId'],
      "deviceType": deviceDetails['deviceType'],
      "deviceToken": deviceToken,
    });

    return _sendRequest(
      requestFn: () => http.post(url, headers: headers, body: body),
      endpoint: endpoint,
      body: body,
    );
  }

  Future<http.Response> updateProfile({
    required String userFirstName,
    required String userLastName,
    required String userEmail,
  }) async {
    final endpoint = '$baseUrl/api/user/profile/update';
    final url = Uri.parse(endpoint);

    final storageService = await StorageService.instance;
    var token = await storageService.token;

    final headers = {
      'accept': '*/*',
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({
      "userFirstName": userFirstName,
      "userLastName": userLastName,
      "useremail": userEmail,
    });

    return _sendRequest(
      requestFn: () => http.put(url, headers: headers, body: body),
      endpoint: endpoint,
      body: body,
    );
  }

  Future<Map<String, String>> getDeviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    String deviceType = '';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id ?? 'unknown';
      deviceType = 'android';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown';
      deviceType = 'ios';
    } else {
      deviceType = 'other';
    }

    return {
      'deviceId': deviceId,
      'deviceType': deviceType,
    };
  }

  Future<VehicleTypeListResponse?> fetchVehicleList() async {
    final endpoint = '$baseUrl/api/vehicle';
    final url = Uri.parse(endpoint);

    return _sendRequest(
      requestFn: () => http.get(
        url,
        headers: {'accept': '*/*'},
      ),
      endpoint: endpoint,
    ).then((response) {
      if (response.statusCode == 200) {
        var responsedata =
        VehicleTypeListResponse().vehicleTypeListResponseFromJson(response.body);
        return responsedata;
      }
      return null;
    });
  }

  Future<ApiResponse> submitReview({
    required AddressModel pickupAddress,
    required AddressModel dropAddress,
    required Vehicle vehicle,
    required String packageType,
    String? couponCode,
    required int numberOfPieces,
  }) async {
    final endpoint = "$baseUrl/api/book/review";
    final url = Uri.parse(endpoint);

    var body = jsonEncode({
      'pickup_address': pickupAddress.toMap(),
      'drop_address': dropAddress.toMap(),
      'vehicle': vehicle.toJson(),
      'package_type': packageType,
      'number_of_pieces': numberOfPieces,
      "coupon_code": couponCode ?? ""
    });

    final response = await _sendRequest(
      requestFn: () => http.post(url, headers: {'Content-Type': 'application/json'}, body: body),
      endpoint: endpoint,
      body: body,
    );

    if (response.statusCode == 200) {
      return ApiResponse(isSuccess: true);
    } else {
      return ApiResponse(isSuccess: false, message: 'Failed: ${response.body}');
    }
  }


}

class ApiResponse {
  final bool isSuccess;
  final String? message;
  ApiResponse({required this.isSuccess, this.message});
}
