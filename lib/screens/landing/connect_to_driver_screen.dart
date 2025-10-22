import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/book_order_controller.dart';
import '../../routes/app_routes.dart';

class ConnectToDriverScreen extends StatefulWidget {
  const ConnectToDriverScreen({super.key});

  @override
  State<ConnectToDriverScreen> createState() => _ConnectToDriverScreenState();
}

class _ConnectToDriverScreenState extends State<ConnectToDriverScreen> {
  final bookOrderController = BookOrderController.instance;

  @override
  void initState() {
    super.initState();
    bookOrderController.searchForDriver();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Obx(() {
      final isSearching = bookOrderController.isSearchingDriver.value;
      final driver = bookOrderController.foundDriver.value;

      return Scaffold(
        appBar: AppBar(
          title: Text("ConnectToDriver", style: theme.appBarTheme.titleTextStyle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.appBarTheme.iconTheme?.color),
            onPressed: () {
              bookOrderController.cancelDriverSearch();
              Navigator.pop(context);
            },
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: theme.appBarTheme.elevation,
        ),
        backgroundColor: colorScheme.background,
        body: Column(
          children: [
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 80,
                        color: colorScheme.primary,
                      ),
                      Container(
                        width: 40,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (isSearching) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LinearProgressIndicator(
                  color: colorScheme.secondary,
                  backgroundColor: colorScheme.secondary.withOpacity(0.3),
                  minHeight: 5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Searching for a driver...",
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/images/scooter_delivery.png',
                  fit: BoxFit.contain,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  bookOrderController.cancelDriverSearch();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ] else if (driver != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(driver['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Vehicle: ${driver['vehicle']}"),
                        Text("Phone: ${driver['phone']}"),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            Text("${driver['rating']}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.driver_acceptance_screen);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Continue", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ] else ...[
              const SizedBox(height: 20),
              const Text("No driver found. Please try again."),
              ElevatedButton(
                onPressed: () {
                  bookOrderController.searchForDriver();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Retry", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      );
    });
  }
}