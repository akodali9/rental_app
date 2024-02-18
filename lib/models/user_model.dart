import 'dart:convert';

import 'package:rental_app/models/order_model.dart';

class UserModel {
  /// What about the Token that you are recieving from the server???
  final String userId;
  final String name;
  final String email;
  // final String password;
  final bool isAdmin;
  final List<String> favoriteProducts;
  final List<String> addressList;
  final List<Order> ordersList;
  final List<OrderItem> shoppingCartList;
  // final num nversion;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    // required this.password,
    required this.isAdmin,
    required this.favoriteProducts,
    required this.addressList,
    required this.ordersList,
    required this.shoppingCartList,
    // required this.nversion,
  });

  // Convert UserModel to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      // 'password': password,
      'isAdmin': isAdmin,
      'favoriteProducts': favoriteProducts,
      'addressList': addressList,
      'ordersList': ordersList.map((order) => order.toMap()).toList(),
      'shoppingCartList': shoppingCartList,
      // '__v': nversion,
    };
  }

  // Create a UserModel instance from a Map (JSON deserialization)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId']?.toString() ?? '',
      name: map['name'] as String,
      email: map['email'] as String,
      // password: map['password'] as String,
      isAdmin: map['isAdmin'] as bool,
      favoriteProducts: (map['favoriteProducts'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      addressList: (map['addressList'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      ordersList: (map['ordersList'] as List<dynamic>?)
              ?.map((order) => Order.fromMap(order as Map<String, dynamic>))
              .toList() ??
          [],
      shoppingCartList: (map['shoppingCartList'] as List<dynamic>?)
              ?.map((orderitem) =>
                  OrderItem.fromMap(orderitem as Map<String, dynamic>))
              .toList() ??
          [],
      // nversion: map['__v'] as num,
    );
  }

  void toggleFavoriteProduct(String productId) {
    if (favoriteProducts.contains(productId)) {
      favoriteProducts.remove(productId);
    } else {
      favoriteProducts.add(productId);
    }
  }

  // Convert UserModel to JSON string
  String toJson() {
    return json.encode(toMap());
  }

  // Create a UserModel instance from a JSON string
  factory UserModel.fromJson(String jsonString) {
    final Map<String, dynamic> map = json.decode(jsonString);
    return UserModel.fromMap(map);
  }
}
