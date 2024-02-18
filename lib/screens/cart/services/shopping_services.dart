import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/order_model.dart';
import 'package:rental_app/screens/cart/providers/shopping_cart_cubit.dart';
import 'package:http/http.dart' as http;

class ShoppingServices {
  static Future<void> updateUserShoppingCart(
      BuildContext context, ShoppingCartCubit shoppingCartCubit) async {
    UserCubit userCubit = context.read<UserCubit>();

    String token = userCubit.state is UserLoadedState
        ? (userCubit.state as UserLoadedState).user.userId
        : 'token';

    final response = await http.post(
      Uri.parse(
        "$uri/user/shopping-cart",
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          "userId": token,
          "shoppingCartList": shoppingCartCubit.loadItems(),
        },
      ),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      List<dynamic> updatedServerCartList = responseData['shoppingCartList'];
      List<OrderItem> convertedCartList =
          updatedServerCartList.map((item) => OrderItem.fromMap(item)).toList();
      userCubit.updateShoppingCartListForUser(convertedCartList);
    }
  }

  static Future<void> addProduct(
    OrderItem newItem,
    BuildContext context,
  ) async {
    ShoppingCartCubit shoppingCartCubit = context.read<ShoppingCartCubit>();
    shoppingCartCubit.addItemToCart(newItem);
    await updateUserShoppingCart(context, shoppingCartCubit);
  }

  static Future<void> decrementQuantity(
    OrderItem item,
    BuildContext context,
  ) async {
    ShoppingCartCubit shoppingCartCubit = context.read<ShoppingCartCubit>();
    shoppingCartCubit.decrementQuantity(item);
    await updateUserShoppingCart(context, shoppingCartCubit);
  }

  static Future<void> incrementQuantity(
    OrderItem item,
    BuildContext context,
  ) async {
    ShoppingCartCubit shoppingCartCubit = context.read<ShoppingCartCubit>();
    shoppingCartCubit.incrementQuantity(item);
    await updateUserShoppingCart(context, shoppingCartCubit);
  }

  static Future<void> deleteItem(
    OrderItem item,
    BuildContext context,
  ) async {
    ShoppingCartCubit shoppingCartCubit = context.read<ShoppingCartCubit>();
    shoppingCartCubit.deleteItem(item);
    await updateUserShoppingCart(context, shoppingCartCubit);
  }
}
