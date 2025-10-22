import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/book_order_controller.dart';
import '../../routes/app_routes.dart';

class PackageSendScreen extends StatefulWidget {
  PackageSendScreen({super.key});

  @override
  State<PackageSendScreen> createState() => _PackageSendScreenState();
}

class _PackageSendScreenState extends State<PackageSendScreen> {

  var bookOrderController = BookOrderController.instance;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: theme.iconTheme.color),
        title: Text(
          'PackageSend',
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStepIndicator(context),
            const SizedBox(height: 16),
            _buildButton(
                context: context,
                text: bookOrderController.pickupAddress.value.fullAddress != null
                    ? "Change Pickup Location"
                    : "Pickup Location",
                onPressed: () async{
                  var pickAddress = await Get.toNamed(AppRoutes.select_address_screen);
                  if(pickAddress!=null){
                    setState(() {
                      bookOrderController.pickupAddress.value = pickAddress;
                    });

                  }
                },
                isLoading: false),
            const SizedBox(height: 10),
            // For showing pickup location card
            if (bookOrderController.pickupAddress.value.fullAddress != null)
              _buildLocationCard(
                context,
                title: 'Pickup Location:',
                address: bookOrderController.pickupAddress.value.fullAddress ?? "",
                name: bookOrderController.pickupAddress.value.addressUserName ?? "",
                mobile: bookOrderController.pickupAddress.value.addressUserMobileNumber ?? "",
                building: bookOrderController.pickupAddress.value.houseNumber ?? "",
                pin: bookOrderController.pickupAddress.value.addressUserPincode ?? "",
              ),
            const SizedBox(height: 16),
            _buildButton(
                context: context,
                text: bookOrderController.destinationAddress.value.fullAddress != null
                    ? "Change Drop Location"
                    : "Drop Location",
                onPressed: () async{
                 var pickAddress = await Get.toNamed(AppRoutes.select_address_screen);
                 if(pickAddress!=null){
                   setState(() {
                     bookOrderController.destinationAddress.value = pickAddress;
                   });


                 }
                },
                isLoading: false),
            const SizedBox(height: 10),
            if (bookOrderController.destinationAddress.value.fullAddress != null)
              _buildLocationCard(
                context,
                title: 'Drop Location:',
                address: bookOrderController.destinationAddress.value.fullAddress ?? "",
                name: bookOrderController.destinationAddress.value.addressUserName ?? "",
                mobile: bookOrderController.destinationAddress.value.addressUserMobileNumber ?? "",
                building: bookOrderController.destinationAddress.value.houseNumber ?? "",
                pin: bookOrderController.destinationAddress.value.addressUserPincode ?? "",
              ),
            const SizedBox(height: 20),
            if (bookOrderController.pickupAddress.value.fullAddress != null &&
                bookOrderController.destinationAddress.value.fullAddress != null)
              _buildButton(
                context: context,
                text: 'Proceed',
                onPressed: () {
                  if (bookOrderController.selectedVehicle.value != null) {
                    Get.toNamed(AppRoutes.select_package_type_screen);
                  } else {
                    Get.toNamed(AppRoutes.select_vehicle, arguments: {
                      "pickupAddress": bookOrderController.pickupAddress.value,
                      "destinationAddress": bookOrderController.destinationAddress.value
                    });
                  }
                },
                isLoading: false,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const _StepIcon(label: 'Address', active: true),
        Icon(Icons.arrow_forward, color: colorScheme.primary),
        const _StepIcon(label: 'Package'),
        Icon(Icons.arrow_forward, color: colorScheme.primary),
        const _StepIcon(label: 'Estimate'),
        Icon(Icons.arrow_forward, color: colorScheme.primary),
        const _StepIcon(label: 'Review'),
      ],
    );
  }

  Widget _buildButton(
      {required BuildContext context,
      required String text,
      required VoidCallback onPressed,
      required bool isLoading}) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }

  Widget _buildLocationCard(
    BuildContext context, {
    required String title,
    required String address,
    required String name,
    required String mobile,
    required String building,
    required String pin,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text(address, style: textTheme.bodyMedium),
            const SizedBox(height: 4),
            _buildRichLine(context, 'Name:', name),
            _buildRichLine(context, 'Mobile:', mobile),
            _buildRichLine(context, 'House/Building:', building),
            _buildRichLine(context, 'Pin Code:', pin),
          ],
        ),
      ),
    );
  }

  Widget _buildRichLine(BuildContext context, String label, String value) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          text: '$label ',
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  final String label;
  final bool active;

  const _StepIcon({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          active ? Icons.check_circle : Icons.circle_outlined,
          color: active ? theme.colorScheme.primary : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: active ? theme.textTheme.bodyLarge?.color : Colors.grey,
          ),
        ),
      ],
    );
  }
}
