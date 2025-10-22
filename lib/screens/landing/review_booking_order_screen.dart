import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/book_order_controller.dart';
import '../../routes/app_routes.dart';

class ReviewBookingOrderScreen extends StatelessWidget {
  ReviewBookingOrderScreen({super.key});
  final bookOrderController = BookOrderController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: const Text("Review Booking Order"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoSection(
              title: "Vehicle Information",
              info: [
                Text(bookOrderController.selectedVehicle.value?.type ?? "N/A"),
                Text.rich(TextSpan(
                  text: "Weight: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "${bookOrderController.selectedVehicle.value?.capacityKg ?? "N/A"} kg",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                )),
                Text.rich(TextSpan(
                  text: "Price: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "₹${bookOrderController.selectedVehicle.value?.farePerKm ?? "N/A"}/KM",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                )),
              ],
              onEditTap: () {
                // Implement navigation to change vehicle if needed
              },
              editLabel: "CHANGE VEHICLE",
            ),
            const Divider(thickness: 1),
            _infoSection(
              title: "Package Information",
              info: [
                Text.rich(TextSpan(
                  text: "Packages - ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: bookOrderController.selectedPackageType ?? "N/A",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                )),
                Text.rich(TextSpan(
                  text: "No. of pieces - ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "${bookOrderController.numberOfPieces ?? "N/A"}",
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                )),
              ],
              onEditTap: () {
                // Implement navigation to change package type if needed
              },
              editLabel: "CHANGE PACKAGE TYPE",
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(value: false, onChanged: (_) {}),
                const Expanded(
                  child: Text("Deliver using Pin Code (Optional)"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter coupon code",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Implement coupon apply logic if needed
                },
                child: const Text("Apply"),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TOTAL DISTANCE :  ${bookOrderController.getDistanceInKm().toStringAsFixed(2)} KM*",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "TOTAL PRICE : ₹${bookOrderController.totalFare.toStringAsFixed(2)}*",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.connect_to_driver_screen);
                },
                child: const Text("Confirm Booking"),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ));
  }

  Widget _infoSection({
    required String title,
    required List<Widget> info,
    required VoidCallback onEditTap,
    required String editLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...info.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: e,
        )),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onEditTap,
          child: Row(
            children: [
              const Icon(Icons.edit, size: 18, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                editLabel,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}