import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/functions/capitalize_first_letter.dart';
import 'package:rental_app/functions/snackbar_showtext.dart';
import 'package:rental_app/models/order_model.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/screens/cart/providers/shopping_cart_cubit.dart';
import 'package:rental_app/screens/cart/services/shopping_services.dart';
import 'package:rental_app/screens/product_view_page/product_detailed_view.dart';

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
                Image.memory(
                  binaryData,
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
                      IconButton.filled(
                          onPressed: () {
                            ShoppingCartCubit shoppingCartCubit =
                                context.read<ShoppingCartCubit>();
                            final List<OrderItem> cartItems = shoppingCartCubit
                                    .state is ShoppingCartLoadedState
                                ? (shoppingCartCubit.state
                                        as ShoppingCartLoadedState)
                                    .shoppingCartList
                                : [];

                            bool matchedItem = cartItems.any((item) =>
                                item.productId == products[index].productId);
                            if (cartItems != [] && matchedItem == true) {
                              showSnackbar(context, 'Already added to cart');
                            } else {
                              final OrderItem item = OrderItem(
                                  productId: products[index].productId,
                                  productName: products[index].name,
                                  quantity: 1,
                                  price: products[index].price);

                              ShoppingServices.addProduct(item, context);
                            }
                          },
                          icon: const Text(
                            '  Add to cart  ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )),

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
