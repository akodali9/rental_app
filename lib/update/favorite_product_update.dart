import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/logout_user.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/screens/favorite/providers/favorite_page_cubit.dart';
import 'package:rental_app/screens/favorite/services/favorite_services.dart';

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
      if (context.mounted) {
        final userCubit = BlocProvider.of<UserCubit>(context);
        final favoriteProductPageCubit =
            BlocProvider.of<FavoriteProductPageCubit>(context);

        if (userCubit.state is UserLoadedState) {
          UserLoadedState loadedState = userCubit.state as UserLoadedState;
          FavoriteServices.fetchFavoriteProducts(
              context, loadedState.user.favoriteProducts);
        } else {
          // Handle other states if needed
        }

        favoriteProductPageCubit.resetFavoriteProducts();
      }
      // print('Favorite products updated on the server');
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
