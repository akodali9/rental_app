import 'package:flutter/material.dart';
import 'package:rental_app/models/order_model.dart';
import 'package:rental_app/screens/cart/services/shopping_services.dart';
import 'package:slide_to_act/slide_to_act.dart';

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({super.key, required this.order});
  final Order order;

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildOrderId(widget.order.orderId ?? ""),
              // const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Total Amount',
                        '${widget.order.totalAmount.toStringAsFixed(2)} INR'),
                    _buildDetailRow('Status', widget.order.status),
                    _buildDetailRow(
                        'Created At', widget.order.createdAt.toString()),
                    _buildDetailRow('Return Status',
                        widget.order.returnStatus ? 'Yes' : 'No'),
                    const SizedBox(height: 16.0),
                    const Divider(),
                    const SizedBox(height: 16.0),
                    Text('Items:',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8.0),
                    ...widget.order.items.map((item) => _buildItemRow(item)),
                    const SizedBox(height: 16.0),
                    const Divider(),
                    const SizedBox(height: 16.0),
                    Text('Customer Address:',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8.0),
                    _buildDetailRow('Name', widget.order.customerAddress.name),
                    _buildDetailRow(
                        'Contact No', widget.order.customerAddress.contactNo),
                    _buildDetailRow(
                        'Street', widget.order.customerAddress.street),
                    _buildDetailRow('City', widget.order.customerAddress.city),
                    _buildDetailRow(
                        'State', widget.order.customerAddress.state),
                    _buildDetailRow(
                        'Postal Code', widget.order.customerAddress.postalCode),
                    _buildDetailRow(
                        'Country', widget.order.customerAddress.country),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              SlideAction(
                innerColor: Theme.of(context).cardColor,
                outerColor: Theme.of(context).bottomAppBarTheme.shadowColor,
                text: 'Confirm Order',
                onSubmit: () async {
                  await ShoppingServices.createOrder(widget.order, context);
                  await Future.delayed(const Duration(seconds: 2));
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildOrderId(String orderId) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Order ID: $orderId',
  //         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
  //       ),
  //       const Divider(),
  //     ],
  //   );
  // }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Widget _buildItemRow(OrderItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.productName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Quantity: ${item.quantity}'),
        Text('Price: ${item.price.toStringAsFixed(2)} INR'),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
