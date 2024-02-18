import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/search/providers/searched_products_cubit.dart';

class SearchService {
  static productSearchCall(BuildContext context, String searchQuery) async {
    final SearchedProductCubit searchedProductCubit =
        context.read<SearchedProductCubit>();
    searchedProductCubit.setSearchedLoadingState();
    final response = await http
        .get(Uri.parse("$uri/product/search?q=$searchQuery"), headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      if (context.mounted) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> productsData = responseBody['products'];

        // Convert the list of dynamic data to a list of Product models
        List<Product> products = productsData
            .map((productData) => Product.fromJson(productData))
            .toList();

        searchedProductCubit.setSearchedProducts(products);
      }
    }
  }
}
