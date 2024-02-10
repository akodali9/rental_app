import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/functions/logout_user.dart';
import 'package:rental_app/global_variables.dart';

Future<void> updateFavoritesOnServer(BuildContext context,
    List<String> favoriteProducts, String token, String userId) async {
  final String apiUrl = '$uri/user/update-favorites';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'userId': userId,
          'favoriteProducts': favoriteProducts,
        },
      ),
    );

    if (response.statusCode == 200) {
      // print('Favorite products updated on the server');
    } else {
      if (response.statusCode == 401) {
        if (context.mounted) {
          logoutuser(context);
        }
      }
    }
  } catch (error) {
    print('Error updating favorite products: $error');
  }
}
