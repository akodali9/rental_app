import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/logout_user.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/order_model.dart';
import 'package:rental_app/screens/cart/providers/shopping_cart_cubit.dart';
import 'package:http/http.dart' as http;

class ShoppingServices {
  static Future<void> updateUserShoppingCart(
      BuildContext context, List<OrderItem> shoppingCartList) async {
    UserCubit userCubit = context.read<UserCubit>();

    String userId = userCubit.state is UserLoadedState
        ? (userCubit.state as UserLoadedState).user.userId
        : 'userId';

    UserTokenCubit userTokenCubit = context.read<UserTokenCubit>();
    String token = userTokenCubit is UserTokenLoadedState
        ? (userTokenCubit.state as UserTokenLoadedState).token
        : 'userId';
    final response = await http.post(
      Uri.parse(
        "$uri/user/shopping-cart",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: json.encode(
        {
          "userId": userId,
          "shoppingCartList": shoppingCartList,
        },
      ),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      List<dynamic> updatedServerCartList = responseData['shoppingCartList'];
      List<OrderItem> convertedCartList =
          updatedServerCartList.map((item) => OrderItem.fromMap(item)).toList();
      userCubit.updateShoppingCartListForUser(convertedCartList);
    } else if (response.statusCode == 401) {
      if (context.mounted) logoutuser(context);
    } 
  }

  static Future<void> addProduct(
    OrderItem newItem,
    BuildContext context,
  ) async {
    ShoppingCartCubit shoppingCartCubit = context.read<ShoppingCartCubit>();
    shoppingCartCubit.addItemToCart(newItem);
    await updateUserShoppingCart(context, shoppingCartCubit.loadItems());
  }

  static Future<void> decrementQuantity(
    OrderItem item,
    BuildContext context,
  ) async {
    ShoppingCartCubit shoppingCartCubit = context.read<ShoppingCartCubit>();
    shoppingCartCubit.decrementQuantity(item);
    await updateUserShoppingCart(context, shoppingCartCubit.loadItems());
  }

  static Future<void> incrementQuantity(
    OrderItem item,
    BuildContext context,
  ) async {
    ShoppingCartCubit shoppingCartCubit = context.read<ShoppingCartCubit>();
    shoppingCartCubit.incrementQuantity(item);
    await updateUserShoppingCart(context, shoppingCartCubit.loadItems());
  }

  static Future<void> deleteItem(
    OrderItem item,
    BuildContext context,
  ) async {
    ShoppingCartCubit shoppingCartCubit = context.read<ShoppingCartCubit>();
    shoppingCartCubit.deleteItem(item);
    await updateUserShoppingCart(context, shoppingCartCubit.loadItems());
  }
}
