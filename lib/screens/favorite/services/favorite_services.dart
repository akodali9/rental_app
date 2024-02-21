import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/functions/logout_user.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/favorite/providers/favorite_page_cubit.dart';

class FavoriteServices {
  static Future<void> fetchFavoriteProducts(
      BuildContext context, List<String> favoriteProducts) async {
    try {
      FavoriteProductPageCubit favoriteProductPageCubit =
          context.read<FavoriteProductPageCubit>();
      // favoriteProductPageCubit.resetFavoriteProducts();
      final String apiUrl = '$uri/user/fetch-favorite';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "favoriteProducts": favoriteProducts,
          },
        ),
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          List<dynamic> favoriteProductsData =
              responseBody['favoriteProductsFetched'];
          List<Product> favoriteProducts = favoriteProductsData
              .map((favoriteProduct) => Product.fromJson(favoriteProduct))
              .toList();
          if (favoriteProducts.isNotEmpty) {
            favoriteProductPageCubit.loadFavoriteProducts(favoriteProducts);
          } else {
            favoriteProductPageCubit.loadFavoriteProducts([]);
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
