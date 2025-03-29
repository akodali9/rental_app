import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/Auth/services/auth_services.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/screens/cart/shopping_cart_page.dart';
import 'package:rental_app/screens/wishlist/wishlist_page.dart';
import 'package:rental_app/screens/home/home_page.dart';
import 'package:rental_app/screens/account/account_page.dart';

class MainAppExtended extends StatefulWidget {
  const MainAppExtended({super.key});
  static const String routename = '/';

  @override
  State<MainAppExtended> createState() => _MainAppExtendedState();
}

class _MainAppExtendedState extends State<MainAppExtended> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    List screens = const [
      HomePage(),
      WishlistPage(),
      ShoppingCartPage(),
      AccountPage(),
    ];
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserInitialState) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome to the rental app',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton.filledTonal(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/auth');
                      },
                      style: const ButtonStyle(
                        enableFeedback: true,
                        elevation: WidgetStatePropertyAll(20.0),
                      ),
                      icon: const Text(
                        "Login/Signup",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        AuthService.guestUserAccess(context);
                      },
                      style: const ButtonStyle(
                        enableFeedback: true,
                        elevation: WidgetStatePropertyAll(20.0),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Continue as Guest",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is UserLoadedState) {
          return Scaffold(
            extendBody: true,
            body: screens[index],
            bottomNavigationBar: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (newIndex) {
                setState(() {
                  index = newIndex;
                });
              },
              elevation: 2.5,
              height: 60,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: [
                const NavigationDestination(
                  label: "Home",
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                ),
                BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                  UserModel user = (state as UserLoadedState).user;
                  return NavigationDestination(
                    label: "Wishlist",
                    icon: user.wishlistProducts.isNotEmpty
                        ? Badge(
                            label: Text('${user.wishlistProducts.length}'),
                            child: const Icon(Icons.favorite_outline))
                        : const Icon(Icons.favorite_outline),
                    selectedIcon: const Icon(Icons.favorite),
                  );
                }),
                BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                  final userCubit = state as UserLoadedState;

                  return NavigationDestination(
                    label: "Cart",
                    icon: userCubit.user.shoppingCartList.isNotEmpty
                        ? Badge(
                            label: Text(
                                '${userCubit.user.shoppingCartList.length}'),
                            child: const Icon(Icons.shopping_cart_outlined))
                        : const Icon(Icons.shopping_cart_outlined),
                    selectedIcon: const Icon(Icons.shopping_cart),
                  );
                }),
                const NavigationDestination(
                  label: "Account",
                  icon: Icon(Icons.account_circle_outlined),
                  selectedIcon: Icon(Icons.account_circle),
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(child: Text("Internal Error")),
        );
      },
    );
  }
}
