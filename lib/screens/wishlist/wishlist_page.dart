import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/Components/sliver_product_display.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/wishlist/providers/wishlist_page_cubit.dart';
import 'package:rental_app/screens/wishlist/services/wishlist_services.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
  }

  void fetchWishlistProducts() {
    final userCubit = BlocProvider.of<UserCubit>(context);

    if (userCubit.state is UserLoadedState) {
      UserLoadedState loadedState = userCubit.state as UserLoadedState;
      WishlistServices.fetchWishlistProducts(
          context, loadedState.user.wishlistProducts);
    } else {
      // Handle other states if needed
    }
  }

  Future<void> onrefresh() async {
    context.read<WishlistProductPageCubit>().resetWishlistProducts();
    fetchWishlistProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Wishlist"),
        centerTitle: true,
      ),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        if (state is UserInitialState) {
          return const LinearProgressIndicator();
        } else if (state is UserLoadedState) {
          final user = (state).user;
          return BlocBuilder<WishlistProductPageCubit,
              WishlistProductPageState>(
            builder: (context, state) {
              if (state is WishlistProductPageInitialState) {
                WishlistServices.fetchWishlistProducts(
                    context, user.wishlistProducts);
                return const LinearProgressIndicator();
              } else if (state is WishlistProductPageLoadedState) {
                List<Product> WishlistProducts = state.WishlistProducts;
                if (WishlistProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      "Wishlist products to see them here\n😊",
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: onrefresh,
                    child: CustomScrollView(
                      slivers: [
                        sliverProductDisplay(WishlistProducts),
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
