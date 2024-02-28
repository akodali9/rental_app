import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/functions/logout_user.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/wishlist/providers/wishlist_page_cubit.dart';

class WishlistServices {
  static Future<void> fetchWishlistProducts(
      BuildContext context, List<String> wishlistProducts) async {
    try {
      WishlistProductPageCubit wishlistProductPageCubit =
          context.read<WishlistProductPageCubit>();
      final String apiUrl = '$uri/user/fetch-wishlist';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "wishlistProducts": wishlistProducts,
          },
        ),
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          Map<String, dynamic> responseBody = await json.decode(response.body);
          List<dynamic> wishlistProductsData =
              responseBody['wishlistProductsFetched'];
          List<Product> wishlistProducts = wishlistProductsData
              .map((wishlistProduct) => Product.fromJson(wishlistProduct))
              .toList();
          if (wishlistProducts.isNotEmpty) {
            wishlistProductPageCubit.loadWishlistProducts(wishlistProducts);
          } else {
            wishlistProductPageCubit.loadWishlistProducts([]);
          }
        }
      } else if (response.statusCode == 401) {
        if (context.mounted) logoutuser(context);
      } else {
        // print('Error recieving products: ${response.statusCode}');
      }
    } catch (error) {
      //
    }
  }
}
