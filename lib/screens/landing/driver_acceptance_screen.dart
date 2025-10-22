import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/book_order_controller.dart';

class DriverAcceptanceScreen extends StatelessWidget {
  DriverAcceptanceScreen({super.key});
  final bookOrderController = BookOrderController.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Get driver and vehicle info from controller
    final driver = bookOrderController.foundDriver.value;
    final vehicle = bookOrderController.selectedVehicle.value;
    final pickupAddress = bookOrderController.pickupAddress.value.fullAddress ?? 'N/A';    final pin = bookOrderController.generatedPin ?? ['-', '-', '-', '-'];
    final driverName = driver?['name'] ?? 'N/A';
    final driverRating = driver?['rating']?.toString() ?? '-';
    final driverVehicle = driver?['vehicle'] ?? vehicle?.type ?? 'N/A';
    final driverPhone = driver?['phone'] ?? '';
    final vehicleNumber = driver?['vehicleNumber'] ?? 'N/A';
    final vehicleModel = driver?['vehicleModel'] ?? vehicle?.type ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('DriverAcceptance', style: theme.appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.iconTheme?.color),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
      ),
      backgroundColor: colorScheme.background,
      body: Column(
        children: [
          // Google Map
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.4220, -122.0841),
                    zoom: 15,
                  ),
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                ),
                Icon(
                  Icons.location_on,
                  size: 60,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),

          // Bottom content
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Captain on the way',
                        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.directions_walk, size: 16, color: colorScheme.onSurface.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text('1.1 km away', style: textTheme.bodyMedium),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text('7 min', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary)),
                            backgroundColor: colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text("Start your order with PIN", style: textTheme.bodyMedium),
                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.onSurface, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          pin[index].toString(),
                          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 10),

                  Text(vehicleNumber, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  Text(vehicleModel, style: textTheme.bodyMedium),
                  Text(driverName, style: textTheme.bodyMedium),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          // Implement message driver logic
                        },
                        child: Text("Message $driverName", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          // Implement trip details logic
                        },
                        child: Text("Trip Details", style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary)),
                      ),
                      Row(
                        children: [
                          Text(driverRating, style: textTheme.bodyMedium),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  const Divider(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Pickup From\n$pickupAddress",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}