import 'package:commv/controllers/book_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var bookOrderController = BookOrderController.instance;


  final List<Map<String, dynamic>> dashboardItems = [
    {'label': 'Bookings', 'icon': Icons.calendar_today},
    {'label': '2 Wheelers', 'image': 'assets/images/2wheeler.jpg'},
    {'label': '3 Wheelers', 'image': 'assets/images/3wheeler.png'},
    {'label': '4 Wheelers', 'image': 'assets/images/4wheeler.png'},
  ];

  @override
  void initState() {
    super.initState();
    bookOrderController.fetchCurrentLocation();


  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(
          () => Scaffold(
        backgroundColor: colorScheme.background,
        body: Column(
          children: [
            // Address Selection UI
            Container(
              padding: const EdgeInsets.all(16),
              color: colorScheme.primary,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddressField(
                          label: "Pickup Location",
                          address: bookOrderController.pickupAddress.value.fullAddress ?? "Select pickup location",
                          icon: Icons.my_location,
                          onTap: () async {
                            var result = await Get.toNamed(AppRoutes.select_address_screen);
                            if (result != null) {
                              bookOrderController.pickupAddress.value = result;
                              bookOrderController.currentAddress.value = result["fullAddress"];
                              bookOrderController.update();
                            }
                          },
                        ),

                        const SizedBox(height: 8),

                        _buildAddressField(
                          label: "Drop Location",
                          address: bookOrderController.destinationAddress.value.fullAddress ?? "Select drop location",
                          icon: Icons.location_on,
                          onTap: () async {
                            var result = await Get.toNamed(AppRoutes.select_address_screen);
                            if (result != null) {
                              bookOrderController.destinationAddress.value = result;
                              bookOrderController.update();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  // 🔄 Swap Button
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.swap_vert, color: colorScheme.onPrimary, size: 28),
                      onPressed: () {
                        // Swap logic
                        final temp = bookOrderController.pickupAddress.value;
                        bookOrderController.pickupAddress.value = bookOrderController.destinationAddress.value;
                        bookOrderController.destinationAddress.value = temp;
                      },
                    ),
                  ),

                ],
              ),
            ),


            const SizedBox(height: 12),

            // Dashboard Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: dashboardItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final item = dashboardItems[index];
                    return GestureDetector(
                      onTap: () {
                        if (index == 0) {
                          bookOrderController.selectedVehicle.value = null;
                              Get.toNamed(AppRoutes.package_sending);
                              bookOrderController.update();
                        }else if(index == 1) {
                          bookOrderController.selectedVehicle.value =  (bookOrderController.vehicles??[])[0];
                          Get.toNamed(AppRoutes.package_sending);
                        }else if(index == 2) {
                          bookOrderController.selectedVehicle.value =  (bookOrderController.vehicles??[])[1];
                          Get.toNamed(AppRoutes.package_sending);
                        }else if(index == 3) {
                          bookOrderController.selectedVehicle.value =  (bookOrderController.vehicles??[])[2];
                          Get.toNamed(AppRoutes.package_sending);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            item['image'] != null
                                ? Image.asset(item['image'], height: 48)
                                : Icon(item['icon'], color: colorScheme.primary, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              item['label'],
                              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            CircleAvatar(
                              backgroundColor: colorScheme.surfaceVariant,
                              child: Icon(Icons.arrow_forward, color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressField({
    required String label,
    required String address,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onPrimary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                address,
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.edit_location_alt, color: colorScheme.onPrimary),
          ],
        ),
      ),
    );
  }
}
