import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/home/home_page.dart';
import 'package:rental_app/screens/home/providers/datafetched_completley_cubit.dart';
import 'package:rental_app/screens/home/providers/home_products_view_cubit.dart';
import 'package:rental_app/functions/snackbar_showtext.dart';

class HomeServices {
  static void clearFecthHistory(String userToken) {
    try {
      http.get(
        Uri.parse(
          '$uri/product/clearfetchhistory',
        ),
        headers: {
          'Authorization': userToken,
          'Content-Type':
              'application/json',
        },
      );
    } catch (error) {
      print(error);
    }
  }

  static Future<List<Product>> fetchRandomProducts(
      int count, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/product/fetchRandom/$count'),
        headers: {
          'Authorization': token,
          'Content-Type':
              'application/json', 
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> productsData = responseBody['products'];

        List<Product> products = productsData
            .map((productData) => Product.fromJson(productData))
            .toList();

        if (context.mounted) {
          final productHomeViewCubit = context.read<HomeProductViewCubit>();
          productHomeViewCubit.loadProducts(
              products); 
        }
        HomePage.dataFetched = true;
        return products;
      } else if (response.statusCode == 404) {

        if (context.mounted) {
          HomeDataFetchedCubit homeDataFetchState =
              context.read<HomeDataFetchedCubit>();
          homeDataFetchState.trueStatus();
          showSnackbar(context, "You have reached the end!");
        }
        return [];
      } else {
        // Handle error[]
        print('Error fetching random products: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle any exceptions
      print('Error: $error');
      return [];
    }
  }
}
