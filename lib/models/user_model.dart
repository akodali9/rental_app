import 'dart:convert';

import 'package:rental_app/models/order_model.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final bool isAdmin;
  final List<String> wishlistProducts;
  final List<AddressModel> addressList;
  final List<Order> ordersList;
  final List<OrderItem> shoppingCartList;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.wishlistProducts,
    required this.addressList,
    required this.ordersList,
    required this.shoppingCartList,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'wishlistProducts': wishlistProducts,
      'addressList': addressList.map((address) => address.toMap()).toList(),
      'ordersList': ordersList.map((order) => order.toMap()).toList(),
      'shoppingCartList': shoppingCartList,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId']?.toString() ?? '',
      name: map['name'] as String,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] as bool,
      wishlistProducts: (map['wishlistProducts'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      addressList: (map['addressList'] as List<dynamic>?)
              ?.map((address) => AddressModel.fromMap(address))
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
    );
  }

  void toggleWishlistProduct(String productId) {
    if (wishlistProducts.contains(productId)) {
      wishlistProducts.remove(productId);
    } else {
      wishlistProducts.add(productId);
    }
  }

  void addAddress(AddressModel address) {
    addressList.add(address);
  }

  void removeAddress(AddressModel address) {
    addressList.remove(address);
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory UserModel.fromJson(String jsonString) {
    final Map<String, dynamic> map = json.decode(jsonString);
    return UserModel.fromMap(map);
  }
}

class AddressModel {
  final String name;
  final String contactNo;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  AddressModel({
    required this.name,
    required this.contactNo,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactNo': contactNo,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      name: map['name'] as String,
      contactNo: map['contactNo'] as String,
      street: map['street'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      postalCode: map['postalCode'] as String,
      country: map['country'] as String,
    );
  }
}
