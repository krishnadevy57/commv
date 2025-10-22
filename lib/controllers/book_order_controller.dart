import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../routes/app_routes.dart';
import '../models/address_model.dart';
import '../models/vehicle_list_response.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class BookOrderController extends GetxController {

  // static BookOrderController get instance => Get.find<BookOrderController>();
  static BookOrderController get instance {
    try {
      return Get.find<BookOrderController>();
    } catch (e) {
      return Get.put(BookOrderController());
    }
  }
  Rx<LatLng> currentLatLng = const LatLng(37.7749, -122.4194).obs; // Default to SF

  var pickupAddress = AddressModel().obs;
  var destinationAddress = AddressModel().obs;
  var currentAddress = 'Fetching address...'.obs;
  final isLoading = false.obs;

  RxList<Vehicle> vehicles = [Vehicle(id: 2, type: "2 Wheeler", farePerKm: 10,baseFare: 50,capacityKg: 20),
    Vehicle(id: 3, type: "3 Wheeler", farePerKm: 15,baseFare: 100,capacityKg: 100),
    Vehicle(id: 4, type: "4 Wheeler", farePerKm: 20,baseFare: 200,capacityKg: 500),].obs;

  Rx<Vehicle?> selectedVehicle = Rx<Vehicle?>(null);

  String? selectedPackageType;
  int? numberOfPieces;

  List<String>? generatedPin = ['4', '2', '2', '5'];

  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
fetchVehicleList();
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Error', 'Location services are disabled.');
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location permission is denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Permission Denied', 'Location permissions are permanently denied. Please enable them from settings.');
      return;
    }

    // If permission granted
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      updateCameraPosition(LatLng(position.latitude, position.longitude));
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }

  double getDistanceInKm() {
    final pickup = pickupAddress.value;
    final drop = destinationAddress.value;
    final lat1 = pickup.latitude;
    final lon1 = pickup.longitude;
    final lat2 = drop.latitude;
    final lon2 = drop.longitude;
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0.0;

    const R = 6371; // Earth radius in km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c;

    return double.parse(distance.toStringAsFixed(2));
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  double get totalFare {
    final distance = getDistanceInKm();
    final farePerKm = selectedVehicle.value?.farePerKm ?? 0;
    return distance * farePerKm;
  }
  void updateCameraPosition(LatLng position) async {
    currentLatLng.value = position;
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

        currentAddress.value =
        "${place.locality}, ${place.administrativeArea}, ${place.country}";
    }
  }

  void bookOrder(String mobile) async {

    isLoading.value = true;

    try {
      // TODO: Replace with real API call
      await Future.delayed(const Duration(seconds: 2));

      Get.offAllNamed(AppRoutes.landing);
    } catch (e) {
      Get.snackbar("Error", "Registration failed: ${e.toString()}",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  static List<String> usageTypes = [
    'Business Usage',
    'Personal Usage',
    'House Shifting Usage',
    'Other',
  ];

  var isSearchingDriver = true.obs;
  var foundDriver = Rxn<Map<String, dynamic>>();

  void searchForDriver() async {
    isSearchingDriver.value = true;
    foundDriver.value = null;
    // Simulate network search
    await Future.delayed(const Duration(seconds: 5));
    // Simulate found driver
    foundDriver.value = {
      'name': 'John Doe',
      'vehicle': 'Scooter',
      'phone': '+91 9876543210',
      'rating': 4.8,
    };
    isSearchingDriver.value = false;
  }

  void cancelDriverSearch() {
    isSearchingDriver.value = false;
    foundDriver.value = null;
  }

  @override
  void onClose() {

    super.onClose();
  }

  Future<void> fetchVehicleList() async {
    try {
      final response = await ApiService().fetchVehicleList();
      if (response!=null) {
        vehicles.value = response.vehicles??[];
        vehicles.refresh();
        // Get.toNamed(AppRoutes.review_booking_order_screen);

      } else {
        Get.snackbar('Error', response?.message ?? 'Failed to submit review');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  Future<void> submitReview({
    required String packageType,
    required int numberOfPieces,
  }) async {
    try {
      final response = await ApiService().submitReview(
        pickupAddress: pickupAddress.value,
        dropAddress: destinationAddress.value,
        vehicle: selectedVehicle.value!,
        packageType: packageType,
        numberOfPieces: numberOfPieces,
      );
      if (response.isSuccess) {
        Get.toNamed(AppRoutes.review_booking_order_screen);
        // Get.toNamed(AppRoutes.review_booking_order_screen);

      } else {
        Get.snackbar('Error', response.message ?? 'Failed to submit review');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
