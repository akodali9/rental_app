import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/alertdialog_customactions.dart';
import 'package:rental_app/functions/snackbar_showtext.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/screens/cart/providers/shopping_cart_cubit.dart';
import 'package:rental_app/screens/cart/services/shopping_services.dart'; // Import your ShoppingCartCubit

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final shoppingCartCubit = context.read<ShoppingCartCubit>();

    if (userCubit.state is UserLoadedState) {
      UserModel user = (userCubit.state as UserLoadedState).user;
      shoppingCartCubit.saveItems(user.shoppingCartList);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
      ),
      body: BlocBuilder<ShoppingCartCubit, ShoppingCartState>(
        builder: (context, state) {
          if (state is ShoppingCartLoadedState) {
            final shoppingCartList = state.shoppingCartList;
            context.read<ShoppingCartCubit>();
            if (shoppingCartList.isEmpty) {
              return const Center(
                child: Text('Your shopping cart is empty.'),
              );
            } else {
              return ListView.builder(
                itemCount: shoppingCartList.length,
                itemBuilder: (context, index) {
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text('Unit: \$${item.price}'),
                                ]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Quantity: ${item.quantity}',
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton.filledTonal(
                                      icon: item.quantity > 1 ?  const Icon(Icons.remove): const Icon(Icons.delete),
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          ShoppingServices.decrementQuantity(
                                              item, context);
                                        } else {
                                          showAlertDialog(
                                              context,
                                              'Do you want to remove "${item.productName}" from Cart?',
                                              [
                                                "Yes",
                                                "No"
                                              ],
                                              [
                                                () {
                                                  ShoppingServices.deleteItem(
                                                      item, context);
                                                  Navigator.pop(context);
                                                },
                                                () {
                                                  Navigator.pop(context);
                                                }
                                              ]);
                                        }
                                      },
                                    ),
                                    IconButton.filledTonal(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        if (item.quantity < 3) {
                                          ShoppingServices.incrementQuantity(
                                              item, context);
                                        } else {
                                          showSnackbar(context,
                                              "Quantity of maximum 3 are allowed per order");
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
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
