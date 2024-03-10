import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/functions/logout_user.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/offer_model.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/home/home_page.dart';
import 'package:rental_app/screens/home/providers/datafetched_completley_cubit.dart';
import 'package:rental_app/screens/home/providers/home_products_view_cubit.dart';
import 'package:rental_app/functions/show_toast.dart';
import 'package:rental_app/screens/home/providers/offers_cubit.dart';

class HomeServices {
  static void clearFetchHistory(String token) async {
    try {
      await http.get(
        Uri.parse(
          '$uri/product/clearfetchhistory',
        ),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
    } catch (error) {
      // print(error);
    }
  }

  static Future<void> fecthOffers(BuildContext context) async {
    final response = await http.get(
      Uri.parse('$uri/admin/get-all-offers-random'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 404) {
      if (response.statusCode == 200) {
        if (context.mounted) {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          final List<dynamic> offerData = responseBody['Offers'];

          List<Offer> offers =
              offerData.map((offer) => Offer.fromJson(offer)).toList();

          context.read<OffersCubit>().setOfferList(offers);
        }
      }
    } else {
      //no offers found
    }
  }

  static Future<List<Product>> fetchRandomProducts(
      int count, String token, BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/product/fetchRandom/$count'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
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
          productHomeViewCubit.loadProducts(products);
        }
        HomePage.dataFetched = true;
        return products;
      } else if (response.statusCode == 404) {
        if (context.mounted) {
          HomeDataFetchedCubit homeDataFetchState =
              context.read<HomeDataFetchedCubit>();
          homeDataFetchState.trueStatus();
          showToast(context, "You have reached the end!");
        }
        return [];
      } else if (response.statusCode == 401) {
        if (context.mounted) logoutuser(context);
        return [];
      } else {
        // Handle error[]
        // print('Error fetching random products: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle any exceptions
      // print('Error: $error');
      return [];
    }
  }
}
