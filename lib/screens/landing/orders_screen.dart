import 'package:commv/routes/app_pages.dart';
import 'package:commv/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  final List<Map<String, dynamic>> orders = const [
    {
      'id': 100,
      'date': '25 Aug 2024',
      'from': 'Guwahati Railway Station Platform Overbridge, Paltan Bazaar, Guwahati, Assam 781001, India',
      'to': 'Borjhar, Guwahati, Assam 781015, India',
      'total': 183.20,
      'paymentMethod': 'Online',
      'status': 'Success',
    },
    {
      'id': 101,
      'date': '31 Aug 2024',
      'from': 'Beltola, Guwahati, Assam 781028, India',
      'to': 'Dispur, Guwahati, Assam 781006, India',
      'total': 300.84,
      'paymentMethod': 'Online',
      'status': 'Success',
    },
    {
      'id': 102,
      'date': '1 Sept 2024',
      'from': 'Ganeshguri, Guwahati, Assam 781005, India',
      'to': 'Jalukbari, Guwahati, Assam 781014, India',
      'total': 181.10,
      'paymentMethod': 'Online',
      'status': 'Success',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final Color statusColor =
        order['status'] == 'Success' ? Colors.green : Colors.orange;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.order_detail_screen);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: theme.colorScheme.primary, width: 5),
                ),
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Order ID & Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order ID: ${order['id']}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        order['date'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 6),

                  /// From & To
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'From: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: order['from']),
                      ],
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'To: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: order['to']),
                      ],
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 12),

                  /// Amount Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${order['total'].toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Payment Method & Status
                  Text(
                    'Payment Method: ${order['paymentMethod']}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    'Status: ${order['status']}',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
