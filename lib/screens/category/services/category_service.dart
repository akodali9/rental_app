import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/functions/logout_user.dart';
import 'package:rental_app/functions/show_toast.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/category/providers/category_provider.dart';
import 'package:rental_app/screens/category/providers/catgeory_fetched.dart';

class CategoryServices {
  static Future<void> getCategory(BuildContext context, String category,
      bool isLoadMore, String userToken) async {
    final response = await http.get(
      Uri.parse("$uri/product/fetchcproducts?q=$category"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': userToken,
      },
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> productsData = responseBody['products'];

        // Convert the list of dynamic data to a list of Product models
        List<Product> products = productsData
            .map((productData) => Product.fromJson(productData))
            .toList();
        CategoryCubit categoryCubit = context.read<CategoryCubit>();
        print(products);
        if (products.isEmpty) {
          context.read<CatgeoryFetched>().setCategoryFetchedState(true);
          showToast(context, responseBody['message']);
        }
        if (isLoadMore) {
          categoryCubit.addCategoryItems(products);
        } else {
          categoryCubit.setCategoryItems(products);
        }
      }
    } else if (response.statusCode == 401) {
      if (context.mounted) {
        logoutuser(context);
      }
    }
  }

  static Future<void> clearCategoryHistory(
      BuildContext context, String userToken) async {
    final response = await http.get(
      Uri.parse("$uri/product/cleartokenhistory"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': userToken,
      },
    );
    if (response.statusCode == 200) {
      if (context.mounted) {
        // showToast(context, json.decode(response.body)['message']);
      }
    } else if (response.statusCode == 401) {
      if (context.mounted) {
        logoutuser(context);
      }
    }
  }
}
