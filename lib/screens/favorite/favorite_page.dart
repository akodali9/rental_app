import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/Components/sliver_product_display.dart';
import 'package:rental_app/models/product_model.dart';
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
  }

  void fetchFavoriteProducts() {
    final userCubit = BlocProvider.of<UserCubit>(context);

    if (userCubit.state is UserLoadedState) {
      UserLoadedState loadedState = userCubit.state as UserLoadedState;
      FavoriteServices.fetchFavoriteProducts(
          context, loadedState.user.favoriteProducts);
    } else {
      // Handle other states if needed
    }
  }

  Future<void> onrefresh() async {
    context.read<FavoriteProductPageCubit>().resetFavoriteProducts();
    fetchFavoriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Favorites"),
        centerTitle: true,
      ),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        if (state is UserInitialState) {
          return const LinearProgressIndicator();
        } else if (state is UserLoadedState) {
          final user = (state).user;
          FavoriteServices.fetchFavoriteProducts(
              context, user.favoriteProducts);
          return BlocBuilder<FavoriteProductPageCubit,
              FavoriteProductPageState>(
            builder: (context, state) {
              if (state is FavoriteProductPageInitialState) {
                return const LinearProgressIndicator();
              } else if (state is FavoriteProductPageLoadedState) {
                List<Product> favoriteProducts = state.favoriteProducts;
                if (favoriteProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      "Favorite products to see them here\n😊",
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: onrefresh,
                    child: CustomScrollView(
                      slivers: [
                        sliverProductDisplay(favoriteProducts),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 60,
                          ),
                        )
                      ],
                    ),
                  );
                }
              } else {
                return const Center(
                  child: Text("Unknown State"),
                );
              }
            },
          );
        } else {
          return const Center(
            child: Text("Unknown State"),
          );
        }
      }),
    );
  }
}
