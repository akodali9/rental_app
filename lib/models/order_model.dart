import 'package:rental_app/models/user_model.dart';

class Order {
  final String? orderId;
  final String customerId;
  final List<OrderItem> items;
  final double totalAmount;
  final AddressModel customerAddress;
  final String status;
  final DateTime createdAt;
  final bool returnStatus;

  Order({
    this.orderId,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.customerAddress,
    required this.status,
    required this.createdAt,
    required this.returnStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'customerAddress':
          customerAddress.toMap(), // Convert AddressModel to a map
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'returnStatus': returnStatus,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      customerId: map['customerId'],
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      customerAddress: AddressModel.fromMap(map['customerAddress']),
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      returnStatus: map['returnStatus'],
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      productName: map['productName'],
      quantity: (map['quantity'] as num).toInt(),
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}
