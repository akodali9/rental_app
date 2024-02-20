import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/capitalize_first_letter.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/product_view_page/product_detailed_view.dart';
import 'package:rental_app/update/favorite_product_update.dart';

SliverList sliverProductDisplay(List<Product> products) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        final binaryData = products[index].images[0].data;
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailedView(
                  product: products[index],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black12,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.memory(
                      binaryData,
                    ),
                    Positioned(
                      top: 3,
                      right: 3,
                      child: BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          final userState = state as UserLoadedState;

                          return IconButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Colors.black87,
                              ),
                            ),
                            onPressed: () async {
                              UserCubit userCubit = context.read<UserCubit>();
                              userCubit.toggleFavoriteProduct(
                                  products[index].productId);

                              UserTokenCubit userTokenCubit =
                                  context.read<UserTokenCubit>();
                              final String userToken =
                                  userTokenCubit.state is UserTokenLoadedState
                                      ? (userTokenCubit.state
                                              as UserTokenLoadedState)
                                          .token
                                      : '';
                              final userLoadedCubit =
                                  userCubit.state as UserLoadedState;
                              await updateFavoritesOnServer(
                                  context,
                                  userLoadedCubit.user.favoriteProducts,
                                  userToken,
                                  userLoadedCubit.user.userId);
                            },
                            icon: userState.user.favoriteProducts
                                    .contains(products[index].productId)
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 26,
                                  )
                                : const Icon(
                                    Icons.favorite_outline_sharp,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              capitalizeFirstLetter(products[index].name),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text('Brand: ${products[index].brand}',
                                style: const TextStyle(fontSize: 16)),
                            // Text('Color: ${products[index].color}'),
                            Text(
                              '${products[index].price} INR/Month',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      // IconButton.filled(
                      //     onPressed: () {
                      //       ShoppingCartCubit shoppingCartCubit =
                      //           context.read<ShoppingCartCubit>();
                      //       final List<OrderItem> cartItems = shoppingCartCubit
                      //               .state is ShoppingCartLoadedState
                      //           ? (shoppingCartCubit.state
                      //                   as ShoppingCartLoadedState)
                      //               .shoppingCartList
                      //           : [];

                      //       bool matchedItem = cartItems.any((item) =>
                      //           item.productId == products[index].productId);
                      //       if (cartItems != [] && matchedItem == true) {
                      //         showToast(context, 'Already added to cart');
                      //       } else {
                      //         final OrderItem item = OrderItem(
                      //             productId: products[index].productId,
                      //             productName: products[index].name,
                      //             quantity: 1,
                      //             price: products[index].price);

                      //         ShoppingServices.addProduct(item, context);
                      //       }
                      //     },
                      //     icon: const Text(
                      //       '  Add to cart  ',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     )),

                      // Card(
                      //   elevation: 3,
                      //   child: SizedBox(
                      //     height: 100,
                      //     width: 100,
                      //     child: Center(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //         children: [
                      //           Text(
                      //             '${products[index].price} INR',
                      //             style: const TextStyle(
                      //               fontSize: 20,
                      //             ),
                      //           ),
                      //           const Divider(
                      //             height: 0,
                      //           ),
                      //           const Text('Month'),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      childCount: products.length,
    ),
  );
}
