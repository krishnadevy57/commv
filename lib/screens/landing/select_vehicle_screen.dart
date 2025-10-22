import 'package:commv/models/vehicle_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/book_order_controller.dart';
import '../../routes/app_routes.dart';

class SelectVehicleScreen extends StatelessWidget {
   SelectVehicleScreen({super.key});
   var bookOrderController = BookOrderController.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // selectedAddress = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('SelectVehicle', style: theme.appBarTheme.titleTextStyle),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildLocationBox(context),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: bookOrderController.vehicles?.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
               itemBuilder: (context, index) {
          final vehicle = (bookOrderController.vehicles??[])[index];
          return _buildVehicleTile(context, vehicle);
          },
            ),
          ),

          Obx(() => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: bookOrderController.selectedVehicle.value == null
                  ? null
                  : () {
                Get.toNamed(AppRoutes.select_package_type_screen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Proceed',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          )),

        ],
      ),
    );
  }

   Widget _buildLocationBox(BuildContext context) {
     final theme = Theme.of(context);
     final colorScheme = theme.colorScheme;

     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 12),
       child: Card(
         color: theme.cardColor,
         child: Padding(
           padding: const EdgeInsets.all(12),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               _locationRow(
                 Icons.location_on,
                 (bookOrderController.pickupAddress.value.fullAddress ?? ''),
                 Colors.green,
                 context,
               ),
               const SizedBox(height: 6),
               _locationRow(
                 Icons.location_on,
                 (bookOrderController.destinationAddress.value.fullAddress ?? ''),
                 Colors.red,
                 context,
               ),
               const SizedBox(height: 6),
               TextButton.icon(
                 onPressed: () {},
                 icon: Icon(Icons.edit, color: colorScheme.primary),
                 label: GestureDetector(
                   onTap: () {
                     Get.back();
                   },
                   child: Text('Edit Locations', style: TextStyle(color: colorScheme.primary)),
                 ),
               )
             ],
           ),
         ),
       ),
     );
   }

  Widget _locationRow(IconData icon, String address, Color iconColor, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            address,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

   Widget _buildVehicleTile(BuildContext context, Vehicle vehicle) {
     final colorScheme = Theme.of(context).colorScheme;
     final textTheme = Theme.of(context).textTheme;

     return Obx(() {
       final isSelected = bookOrderController.selectedVehicle.value?.type == vehicle.type;

       return Card(
         margin: const EdgeInsets.symmetric(vertical: 4),
         color: isSelected ? colorScheme.primary.withOpacity(0.1) : null,
         child: ListTile(
           title: Text(
             vehicle.type ?? '',
             style: textTheme.bodyLarge?.copyWith(
               fontWeight: FontWeight.bold,
               color: isSelected ? colorScheme.primary : null,
             ),
           ),
           trailing: Text(
             "${vehicle.farePerKm}/KM",
             style: TextStyle(
               color: isSelected ? colorScheme.primary : colorScheme.onSurface,
               fontWeight: FontWeight.bold,
             ),
           ),
           onTap: () {
             bookOrderController.selectedVehicle.value = vehicle;
           },
         ),
       );
     });
   }

}
