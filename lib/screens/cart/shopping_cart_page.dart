import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/Components/address_form.dart';
import 'package:rental_app/functions/alertdialog_customactions.dart';
import 'package:rental_app/functions/show_toast.dart';
import 'package:rental_app/models/order_model.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/screens/cart/providers/cart_price_cubit.dart';
import 'package:rental_app/screens/cart/providers/shopping_cart_cubit.dart';
import 'package:rental_app/screens/cart/services/shopping_services.dart';
import 'package:rental_app/screens/order/order_confirm_page.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  void initState() {
    super.initState();
    final userCubit = BlocProvider.of<UserCubit>(context);

    if (userCubit.state is UserLoadedState) {
      UserLoadedState loadedState = userCubit.state as UserLoadedState;
      context
          .read<ShoppingCartCubit>()
          .updateShoppingCart(loadedState.user.shoppingCartList);
    } else {
      // Handle other states if needed
    }
  }

  Future<AddressModel?> showAddressSelectionDialog(BuildContext context) async {
    Completer<AddressModel?> completer = Completer<AddressModel?>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Implement a dialog or navigate to an address selection page
        // Return the selected address
        // For simplicity, let's assume you have a list of addresses in the user's state
        final userState = context.read<UserCubit>().state;
        if (userState is UserLoadedState) {
          final List<AddressModel> addresses = userState.user.addressList;
          return AlertDialog(
            alignment: Alignment.center,
            scrollable: true,
            title: const Text('Select Address'),
            content: addresses.isNotEmpty
                ? Column(
                    children: addresses.map((address) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(address.street),
                          subtitle: Text('${address.city}, ${address.state}'),
                          onTap: () {
                            Navigator.pop(context);
                            completer.complete(address);
                          },
                        ),
                      );
                    }).toList(),
                  )
                : const Center(
                    child: Text('No addresses found'),
                  ),
            actions: [
              TextButton(
                  onPressed: () async {
                    showModalBottomSheet(
                      showDragHandle: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const AddressForm(),
                    ).then((value) => {
                          Navigator.pop(context)
                          // rentNow(context);
                        });
                  },
                  child: const Text("Add new Address"))
            ],
          );
        }
        return const SizedBox(); // Handle other user states if needed
      },
    );

    return completer.future;
  }

  void rentNow(BuildContext context) async {
    try {
      final shoppingCartState = context.read<ShoppingCartCubit>().state;
      if (shoppingCartState is ShoppingCartLoadedState) {
        final shoppingCartList = shoppingCartState.shoppingCartList;

        // Show address selection dialog
        final selectedAddress = await showAddressSelectionDialog(context);

        // Ensure a valid address is selected
        if (selectedAddress == null) {
          // Optionally, show a message to the user indicating that an address is required
          return;
        }
        if (context.mounted) {
          final userState = context.read<UserCubit>().state;
          if (userState is UserLoadedState) {
            final userId = userState.user.userId;

            // Create an order object based on the shopping cart items and the selected address
            final order = Order(
              customerId: userId,
              items: shoppingCartList,
              totalAmount: calculateTotalCost(shoppingCartList),
              customerAddress: selectedAddress,
              status: "Pending",
              createdAt: DateTime.now(),
              returnStatus: false,
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ConfirmOrderPage(order: order),
              ),
            );
          }
        }

        // Extract userId and other details
      }
    } catch (error) {
      // Handle errors
      // Optionally, show an error message to the user
    }
  }

  double getTotalCost(quantity, price) {
    return quantity * price;
  }

  double calculateTotalCost(List<OrderItem> orderItems) {
    double totalCost = 0.0;

    for (OrderItem orderItem in orderItems) {
      totalCost += getTotalCost(orderItem.quantity, orderItem.price);
    }

    return totalCost;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartPriceCubit, CartPriceState>(
        builder: (context, state) {
      if (state is CartPriceLoadingState) {
        final totalCost = state.totalCost;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Cart'),
            centerTitle: true,
          ),
          body: BlocListener<UserCubit, UserState>(
            listener: (context, userState) {
              if (userState is UserLoadedState) {
                UserModel user = userState.user;
                context
                    .read<ShoppingCartCubit>()
                    .updateShoppingCart(user.shoppingCartList);
              }
            },
            child: BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
              builder: (context, state) {
                if (state is ShoppingCartLoadedState) {
                  final shoppingCartList = state.shoppingCartList;
                  if (shoppingCartList.isEmpty) {
                    return const Center(
                      child: Text('Your Shopping cart is empty!'),
                    );
                  } else {
                    double total = calculateTotalCost(shoppingCartList);

                    context.read<CartPriceCubit>().loadComputedPrice(total);

                    return CustomScrollView(
                      slivers: [
                        // SliverToBoxAdapter(
                        //   child: totalCost != 0
                        //       ? Align(
                        //           alignment: Alignment.topRight,
                        //           child: Container(
                        //             width: 100,
                        //             padding: const EdgeInsets.only(right: 10.0),
                        //             child: IconButton.filledTonal(
                        //                 onPressed: () {
                        //                   showAlertDialog(
                        //                       context, "Are you sure?", [
                        //                     "Yes",
                        //                     "No"
                        //                   ], [
                        //                     () {
                        //                       context
                        //                           .read<ShoppingCartCubit>()
                        //                           .clearShoppingList();
                        //                       ShoppingServices
                        //                           .updateUserShoppingCart(
                        //                               context, []);
                        //                       context
                        //                           .read<CartPriceCubit>()
                        //                           .loadInitialPrice();
                        //                       Navigator.pop(context);
                        //                     },
                        //                     () {
                        //                       Navigator.pop(context);
                        //                     }
                        //                   ]);
                        //                 },
                        //                 icon: const Text("Clear All")),
                        //           ),
                        //         )
                        //       : const SizedBox(),
                        // ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: shoppingCartList.length,
                            (context, index) {
                              final item = shoppingCartList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.productName,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            Text('Unit: ${item.price} INR'),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                'Quantity: ${item.quantity}',
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton.filledTonal(
                                                  icon:
                                                      const Icon(Icons.remove),
                                                  onPressed: () {
                                                    if (item.quantity > 1) {
                                                      ShoppingServices
                                                          .decrementQuantity(
                                                              item, context);
                                                    } else {
                                                      showAlertDialog(
                                                        context,
                                                        'Do you want to remove "${item.productName}" from Cart?',
                                                        ["Yes", "No"],
                                                        [
                                                          () {
                                                            ShoppingServices
                                                                .deleteItem(
                                                                    item,
                                                                    context);
                                                            Navigator.pop(
                                                                context);
                                                            context
                                                                .read<
                                                                    CartPriceCubit>()
                                                                .loadInitialPrice();
                                                          },
                                                          () {
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        ],
                                                      );
                                                    }
                                                  },
                                                ),
                                                IconButton.filledTonal(
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () {
                                                    if (item.quantity < 2) {
                                                      ShoppingServices
                                                          .incrementQuantity(
                                                              item, context);
                                                    } else {
                                                      showToast(context,
                                                          "Quantity of maximum 2 are allowed per product");
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 130,
                          ),
                        )
                      ],
                    );
                  }
                } else if (state is ShoppingCartInitialState) {
                  return const LinearProgressIndicator();
                } else {
                  return const Center(
                    child: Text("Unknown state"),
                  );
                }
              },
            ),
          ),
          floatingActionButton: totalCost != 0
              ? Container(
                  margin:
                      const EdgeInsets.only(bottom: 50, left: 10, right: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(10),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        rentNow(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Rent now",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          totalCost != 0
                              ? Text(
                                  "Total: $totalCost INR",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
