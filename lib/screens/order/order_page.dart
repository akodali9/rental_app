import 'package:flutter/material.dart';
import 'package:rental_app/models/order_model.dart';
import 'package:rental_app/screens/cart/services/shopping_services.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key, required this.userId});
  final String userId;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Order>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = ShoppingServices.fetchOrders(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder<List<Order>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal:  16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    
                    title: Text('Order ID: ${order.orderId}'),
                    subtitle: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
                        Text('Status: ${order.status}'),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: const MaterialStatePropertyAll(5.0),
                            shape: MaterialStatePropertyAll(
                              
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailPage(order: order),
                              ),
                            );
                          },
                          child: const Text('View Details'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

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
              _buildOrderId(order.orderId ?? ""),
              const SizedBox(height: 16.0),
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
                        '\$${order.totalAmount.toStringAsFixed(2)}'),
                    _buildDetailRow('Status', order.status),
                    _buildDetailRow('Created At', order.createdAt.toString()),
                    _buildDetailRow(
                        'Return Status', order.returnStatus ? 'Yes' : 'No'),
                    const SizedBox(height: 16.0),
                    const Divider(),
                    const SizedBox(height: 16.0),
                    Text('Items:',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8.0),
                    ...order.items.map((item) => _buildItemRow(item)),
                    const SizedBox(height: 16.0),
                    const Divider(),
                    const SizedBox(height: 16.0),
                    Text('Customer Address:',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8.0),
                    _buildDetailRow('Name', order.customerAddress.name),
                    _buildDetailRow(
                        'Contact No', order.customerAddress.contactNo),
                    _buildDetailRow('Street', order.customerAddress.street),
                    _buildDetailRow('City', order.customerAddress.city),
                    _buildDetailRow('State', order.customerAddress.state),
                    _buildDetailRow(
                        'Postal Code', order.customerAddress.postalCode),
                    _buildDetailRow('Country', order.customerAddress.country),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderId(String orderId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order ID: $orderId',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const Divider(),
      ],
    );
  }

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
        Text('Price: \$${item.price.toStringAsFixed(2)}'),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
