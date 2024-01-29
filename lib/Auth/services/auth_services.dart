import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/Auth/provider/auth_switch.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/functions/snackbar_showtext.dart';

class AuthService {
  static void guestUserAccess(BuildContext context) {
    // List<Item> items = [
    //   Item(productId: '1', productName: 'Product A', quantity: 2, price: 10.99),
    //   Item(productId: '2', productName: 'Product B', quantity: 1, price: 5.99),
    //   Item(productId: '3', productName: 'Product C', quantity: 3, price: 8.99),
    // ];
    // double calculateTotalAmount(List<Item> items) {
    //   return items.fold(
    //       0, (total, item) => total + (item.quantity * item.price));
    // }

    // List<Order> orders = [
    //   Order(
    //     orderId: '123456',
    //     customerId: '7890',
    //     items: items,
    //     totalAmount: calculateTotalAmount(items),
    //     customerAddress: '123 Main St, Cityville',
    //     status: 'Pending',
    //     createdAt: DateTime.now(),
    //     returnStatus: false,
    //   ),
    // ];

    UserModel user = UserModel(
      userId: 'guestUserId',
      name: 'Guest User',
      email: 'guest@example.com',
      isAdmin: false,
      favoriteProducts: [],
      addressList: [],
      ordersList: [],
    );

    final userCubit = context.read<UserCubit>();
    userCubit.setUser(user);
    Navigator.of(context).popAndPushNamed('/');
  }

  static Future<void> userSignup(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    final userJson = {
      "name": name,
      "email": email,
      "password": password, // Fix typo in the key
    };

    try {
      final response = await http.post(
        Uri.parse('$uri/users/Signup'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(userJson),
      );
      if (context.mounted) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (response.statusCode != 500) {
          if (response.statusCode == 200) {
            showSnackbar(context, responseBody['Status']);
            BlocProvider.of<AuthSwitchCubit>(context).changeBool();
          } else if (response.statusCode == 409) {
            showSnackbar(context, responseBody['error']);
          }
        } else {
          showSnackbar(context, responseBody['Status']);
        }
      }
    } catch (error) {
      // print(error);
    }
  }

  static Future<void> userLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    final userJson = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse('$uri/users/Login'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(userJson),
      );
      if (context.mounted) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (response.statusCode != 500) {
          if (response.statusCode == 200) {
            final Map<String, dynamic> userMap = responseBody['user'];
            UserModel user = UserModel.fromMap(userMap);
            final userCubit = context.read<UserCubit>();
            userCubit.setUser(user);
            final userTokenCubit = context.read<UserTokenCubit>();
            userTokenCubit.saveToken(responseBody['token']);
            Navigator.of(context).pop();
            showSnackbar(context, responseBody['Status']);
          } else if (response.statusCode == 401) {
            showSnackbar(context, responseBody['error']);
          }
        } else {
          showSnackbar(context, responseBody['Status']);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
