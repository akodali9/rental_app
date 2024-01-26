import 'dart:convert'; // Add this import statement for json.encode

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/Auth/provider/auth_switch.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/user_model.dart';

Future<void> authSignup(
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
      Uri.parse('$url/users/Signup'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(userJson),
    );
    if (context.mounted) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode != 500) {
        if (response.statusCode == 200) {
          _showSnackbar(context, responseBody['Status']);
          BlocProvider.of<AuthSwitchCubit>(context).changeBool();
        } else if (response.statusCode == 409) {
          _showSnackbar(context, responseBody['error']);
        }
      } else {
        _showSnackbar(context, responseBody['Status']);
      }
    }
  } catch (error) {
    // print(error);
  }
}

_showSnackbar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> authLogin(
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
      Uri.parse('$url/users/Login'),
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
          Navigator.of(context).popAndPushNamed('/');
          _showSnackbar(context, responseBody['Status']);
        } else if (response.statusCode == 401) {
          _showSnackbar(context, responseBody['error']);
        }
      } else {
        _showSnackbar(context, responseBody['Status']);
      }
    }
  } catch (error) {
    print(error);
  }
}
