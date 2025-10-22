import 'dart:convert';
import 'dart:io';
import 'package:commv/services/storage_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

import '../models/address_model.dart';
import '../models/vehicle_list_response.dart';

class ApiService {
  final String baseUrl = 'https://commv.skillupstream.com';

  Future<http.Response> sendOtp(String phoneNumber) async {
    final url = Uri.parse('$baseUrl/api/user/usermobileno/send-otp');

    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({"userphoneNo": phoneNumber});

    return await http.post(url, headers: headers, body: body);
  }


  Future<http.Response> loginVerifyOtp({
    required String otp,
    required String userphoneNo,
    required String deviceToken,
  }) async {
    final url = Uri.parse('$baseUrl/api/user/usermobilenootp/verify');

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

    return await http.post(url, headers: headers, body: body);
  }

  Future<http.Response> updateProfile({
    required String userFirstName,
    required String userLastName,
    required String userEmail,
  }) async {
    final url = Uri.parse('$baseUrl/api/user/profile/update');

    final storageService = await StorageService.instance; // Get stored token
    var token = await storageService.token;
    final headers = {
      'accept': '*/*',
      "Content-Type": "application/json",
      "Authorization": "Bearer ${storageService.token}", // Include the token here
    };


    final body = jsonEncode({
      "userFirstName": userFirstName,
      "userLastName": userLastName,
      "useremail": userEmail,
    });

    return await http.put(url, headers: headers, body: body);
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
    }else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown';
      deviceType = 'other';
    }

    return {
      'deviceId': deviceId,
      'deviceType': deviceType,
    };
  }


  Future<VehicleTypeListResponse?> fetchVehicleList() async {
    final url = Uri.parse('$baseUrl/api/vehicle');

    try {
      final response = await http.get(
        url,
        headers: {
          'accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');
        // You can decode JSON here if needed
        // final data = jsonDecode(response.body);
        var responsedata = VehicleTypeListResponse().vehicleTypeListResponseFromJson(response.body);
        return responsedata;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

   Future<ApiResponse> submitReview({
    required AddressModel pickupAddress,
    required AddressModel dropAddress,
    required Vehicle vehicle,
    required String packageType,
     String? couponCode,
    required int numberOfPieces,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/api/submit-review");

     var body = jsonEncode({
        'pickup_address': pickupAddress.toMap(),
        'drop_address': dropAddress.toMap(),
        'vehicle': vehicle.toJson(),
        'package_type': packageType,
        'number_of_pieces': numberOfPieces,
        "coupon_code": couponCode??""
      });


      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body:body,
      );


      if (response.statusCode == 200) {
        return ApiResponse(isSuccess: true);
      } else {
        return ApiResponse(isSuccess: false, message: 'Failed: ${response.body}');
      }
    } catch (e) {
      return ApiResponse(isSuccess: false, message: e.toString());
    }
  }
}
class ApiResponse {
  final bool isSuccess;
  final String? message;
  ApiResponse({required this.isSuccess, this.message});
}