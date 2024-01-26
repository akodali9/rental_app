class Order {
  final String orderId;
  final String customerId;
  final List<Item> items;
  final double totalAmount;
  final String customerAddress;
  final String status;
  final DateTime createdAt;
  final bool returnStatus;

  Order({
    required this.orderId,
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
      'customerAddress': customerAddress,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'returnStatus': returnStatus,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'],
      customerId: map['customerId'],
      items: (map['items'] as List<Map<String, dynamic>>)
          .map((itemMap) => Item.fromMap(itemMap))
          .toList(),
      totalAmount: map['totalAmount'],
      customerAddress: map['customerAddress'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      returnStatus: map['returnStatus'],
    );
  }
}

class Item {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  Item({
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

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      productId: map['productId'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
