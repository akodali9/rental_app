import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/Auth/provider/auth_switch.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/logout_user.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/functions/snackbar_showtext.dart';

class AuthService {
  static void tokenVerify(BuildContext context, String token) async {
    final response = await http.get(
      Uri.parse('$uri/users/tokenverify'),
      headers: {
        "Authorization": token,
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 401) {
      if (context.mounted) logoutuser(context);
    }
  }

  static void guestUserAccess(BuildContext context) async {
    UserModel user = UserModel(
      userId: 'guestUserId',
      name: 'Guest User',
      email: 'guest@example.com',
      isAdmin: false,
      favoriteProducts: [],
      addressList: [],
      ordersList: [],
      shoppingCartList: [],
    );

    final response = await http.get(
      Uri.parse('$uri/users/guestLogin'),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (context.mounted) {
        final userCubit = context.read<UserCubit>();
        userCubit.setUser(user);
        final userTokenCubit = context.read<UserTokenCubit>();
        userTokenCubit.saveToken(responseBody['token']);
        Navigator.of(context).popAndPushNamed('/');
      }
    }
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
            final userTokenCubit = context.read<UserTokenCubit>();
            userTokenCubit.saveToken(responseBody['token']);
            final Map<String, dynamic> userMap = responseBody['user'];
            UserModel user = UserModel.fromMap(userMap);
            final userCubit = context.read<UserCubit>();
            userCubit.setUser(user);
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
      // print(error);
    }
  }
}
