import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/capitalize_first_letter.dart';
import 'package:rental_app/functions/show_toast.dart';
import 'package:rental_app/models/order_model.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/screens/cart/providers/shopping_cart_cubit.dart';
import 'package:rental_app/screens/cart/services/shopping_services.dart';
import 'package:rental_app/update/wishlist_product_update.dart';

class ProductDetailedView extends StatefulWidget {
  const ProductDetailedView({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailedView> createState() => _ProductDetailedViewState();
}

class _ProductDetailedViewState extends State<ProductDetailedView> {
  final String heroFavoriteTag = 'herofavorite';
  bool showMoreDescription = false;

  bool showProductDetails = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoadedState) {
          final UserModel user = state.user;
          bool isFavorite =
              user.wishlistProducts.contains(widget.product.productId);
          return Scaffold(
            appBar: AppBar(),
            extendBody: true,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton.extended(
              heroTag: heroFavoriteTag,
              label: const Text("Wishlist"),
              onPressed: () async {
                UserCubit userCubit = context.read<UserCubit>();
                userCubit.toggleWishlistProduct(widget.product.productId);

                UserTokenCubit userTokenCubit = context.read<UserTokenCubit>();
                final String userToken =
                    userTokenCubit.state is UserTokenLoadedState
                        ? (userTokenCubit.state as UserTokenLoadedState).token
                        : '';
                await updateWishlistOnServer(
                    context, user.wishlistProducts, userToken, user.userId);
              },
              icon: isFavorite
                  ? const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border_rounded),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3.6,
                    // width: MediaQuery.of(context).size.width,
                    child: Swiper(
                      itemCount: widget.product.images.length,
                      autoplay: true,
                      loop: true,
                      autoplayDisableOnInteraction: true,
                      scrollDirection: Axis.horizontal,
                      pagination: SwiperPagination(
                        builder: SwiperCustomPagination(
                          builder: (BuildContext context,
                              SwiperPluginConfig config) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: config.itemCount * 16,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: config.itemCount > 0
                                      ? List.generate(
                                          config.itemCount,
                                          (index) => Container(
                                            margin: const EdgeInsets.all(4.0),
                                            width: 6.0,
                                            height: 6.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: index == config.activeIndex
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        )
                                      : [],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      itemBuilder: (context, index) {
                        if (widget.product.images.isEmpty){
                          return const Center(child: Text("Error retrieving images", style: TextStyle(fontSize: 20),),);
                        }
                        return Image.memory(
                          widget.product.images[index].data,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    capitalizeFirstLetter(widget.product.name),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Card(
                                  elevation: 3,
                                  child: SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '${widget.product.price} INR',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Divider(
                                              thickness: 2, height: 0),
                                          const Text(
                                            'Month',
                                            style: TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        const Text(
                          "Description:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          capitalizeFirstLetter(widget.product.description),
                          maxLines: showMoreDescription ? 20 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showMoreDescription = !showMoreDescription;
                            });
                          },
                          child: Text(
                            showMoreDescription ? 'Show Less' : 'Show More',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showProductDetails = !showProductDetails;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Product Details:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                showProductDetails
                                    ? const Icon(
                                        Icons.remove,
                                        size: 30,
                                      )
                                    : const Icon(
                                        Icons.add,
                                        size: 30,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        if (showProductDetails)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Brand: ${capitalizeFirstLetter(widget.product.brand)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Category: ${capitalizeFirstLetter(widget.product.category)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Color: ${capitalizeFirstLetter(widget.product.color)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (widget.product.model != "")
                                      Text(
                                        'model: ${capitalizeFirstLetter(widget.product.model)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    if (widget.product.size != "")
                                      Text(
                                        'Size: ${capitalizeFirstLetter(widget.product.size)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    widget.product.material != '""'
                                        ? Text(
                                            'Material: ${capitalizeFirstLetter(widget.product.material)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                        : const SizedBox(),
                                    Text(
                                      'In-stock: ${widget.product.itemCount} units',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    widget.product.otherDetails != ""
                                        ? Text(
                                            'Other Details: \n${widget.product.otherDetails}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          width: double.infinity,
                          child: IconButton.filledTonal(
                            onPressed: () {
                              ShoppingCartCubit shoppingCartCubit =
                                  context.read<ShoppingCartCubit>();
                              final List<OrderItem> cartItems =
                                  shoppingCartCubit.state
                                          is ShoppingCartLoadedState
                                      ? (shoppingCartCubit.state
                                              as ShoppingCartLoadedState)
                                          .shoppingCartList
                                      : [];

                              bool matchedItem = cartItems.any((item) =>
                                  item.productId == widget.product.productId);
                              if (cartItems != [] && matchedItem == true) {
                                showToast(context, 'Already added to cart');
                              } else if (cartItems != [] &&
                                  cartItems.length >= 2) {
                                showToast(context,
                                    'More than 2 products cannot be added to cart');
                              } else {
                                final OrderItem item = OrderItem(
                                    productId: widget.product.productId,
                                    productName: widget.product.name,
                                    quantity: 1,
                                    price: widget.product.price);

                                ShoppingServices.addProduct(item, context);
                              }
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ManageOrdersPage(
                              //       finalOrder:
                              //           createOrderFromProduct(widget.product),
                              //     ),
                              //   ),
                              // );
                            },
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            icon: const Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.symmetric(
                        //     vertical: 5,
                        //   ),
                        //   width: double.infinity,
                        //   child: IconButton(
                        //       // highlightColor:  Colors.green[200],
                        //       onPressed: () {},
                        //       style: ButtonStyle(
                        //           backgroundColor: MaterialStatePropertyAll(
                        //               Colors.green[200]),
                        //           shape: MaterialStatePropertyAll(
                        //               RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       BorderRadius.circular(10)))),
                        //       icon: const Text(
                        //         "Rent now",
                        //         style: TextStyle(
                        //           fontSize: 24,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       )),
                        // ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (state is UserInitialState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(
            child: Text("Unknown State"),
          );
        }
      },
    );
  }
}
