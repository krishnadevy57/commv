import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/book_order_controller.dart';
import '../../routes/app_routes.dart';

class SelectPackageTypeScreen extends StatefulWidget {
  const SelectPackageTypeScreen({super.key});

  @override
  State<SelectPackageTypeScreen> createState() => _SelectPackageTypeScreenState();
}

class _SelectPackageTypeScreenState extends State<SelectPackageTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  var bookOrderController = BookOrderController.instance;

  String? _selectedPackageType;
  String? _pieces;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(
          () => Scaffold(
        appBar: AppBar(
          title: const Text("SelectPackageType"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Pickup Location:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(bookOrderController.pickupAddress.value.fullAddress ?? ""),
                        const Text("Drop Location:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(bookOrderController.destinationAddress.value.fullAddress ?? ""),                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit, color: Colors.red),
                          label: const Text("EDIT LOCATIONS", style: TextStyle(color: Colors.red)),
                        ),
                        const SizedBox(height: 8),
                        const Text("Vehicle:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(bookOrderController.selectedVehicle.value?.type ?? ""),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit, color: Colors.red),
                          label: const Text("CHANGE VEHICLE", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price/KM:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Total Approx:", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${bookOrderController.selectedVehicle.value?.farePerKm ?? 0}/KM",
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                             Text("₹${double.parse(((bookOrderController.selectedVehicle.value?.farePerKm??0)*bookOrderController.getDistanceInKm()).toStringAsFixed(2))}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Package Type",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedPackageType,
                  items: const [
                    DropdownMenuItem(value: "Cartoon", child: Text("Cartoon")),
                    DropdownMenuItem(value: "Bags", child: Text("Bags")),
                    DropdownMenuItem(value: "Loose Items", child: Text("Loose Items")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPackageType = value;
                    });
                  },
                  validator: (value) => value == null || value.isEmpty ? "Please select a package type" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "No. of pieces",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _pieces = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter number of pieces";
                    }
                    final n = int.tryParse(value);
                    if (n == null || n <= 0) {
                      return "Enter a valid positive number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save to controller if needed
                        bookOrderController.selectedPackageType = _selectedPackageType;
                        bookOrderController.numberOfPieces = int.parse(_pieces!);
                        bookOrderController.submitReview(packageType: bookOrderController.selectedPackageType??"", numberOfPieces:  bookOrderController.numberOfPieces??1);
                      }
                    },
                    child: const Text("Proceed", style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}