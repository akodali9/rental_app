import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/functions/logout_user.dart';
import 'package:rental_app/functions/show_toast.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/screens/wishlist/providers/wishlist_page_cubit.dart';

Future<void> updateWishlistOnServer(BuildContext context,
    List<String> favoriteProducts, String token, String userId) async {
  final String apiUrl = '$uri/user/update-wishlist';

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
      if (context.mounted) {
        WishlistProductPageCubit favoriteProductPageCubit =
            context.read<WishlistProductPageCubit>();
        favoriteProductPageCubit.resetWishlistProducts();
        showToast(context, "Updated Wishlist");
      }
    } else {
      if (response.statusCode == 401) {
        if (context.mounted) {
          logoutuser(context);
        }
      }
    }
  } catch (error) {
    // print('Error updating favorite products: $error');
  }
}
