import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/Components/sliver_product_display.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/screens/favorite/providers/favorite_page_cubit.dart';
import 'package:rental_app/screens/favorite/services/favorite_services.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();

    // Fetch favorite products when the screen is initialized
    fetchFavoriteProducts();
  }

  void fetchFavoriteProducts() {
    final userCubit = BlocProvider.of<UserCubit>(context);
    final favoriteProductPageCubit =
        BlocProvider.of<FavoriteProductPageCubit>(context);

    if (userCubit.state is UserLoadedState) {
      UserLoadedState loadedState = userCubit.state as UserLoadedState;
      print("User Favorite Products ${loadedState.user.favoriteProducts}");
      FavoriteServices.fetchFavoriteProducts(
          context, loadedState.user.favoriteProducts);
    } else {
      // Handle other states if needed
    }

    favoriteProductPageCubit.resetFavoriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Favorites"),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteProductPageCubit, FavoriteProductPageState>(
        builder: (context, state) {
          if (state is FavoriteProductPageInitialState) {
            return const LinearProgressIndicator();
          } else if (state is FavoriteProductPageLoadedState) {
            List<Product> favoriteProducts = state.favoriteProducts;
            return CustomScrollView(
              slivers: [
                sliverProductDisplay(favoriteProducts),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 60,
                  ),
                )
              ],
            );
          } else {
            return const Center(
              child: Text("Unknown State"),
            );
          }
        },
      ),
    );
  }
}
