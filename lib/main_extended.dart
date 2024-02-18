import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/Auth/services/auth_services.dart';
import 'package:rental_app/screens/cart/shopping_cart_page.dart';
import 'package:rental_app/screens/favorite/favorite_page.dart';
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
      FavoritePage(),
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
                        elevation: MaterialStatePropertyAll(20.0),
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
                        elevation: MaterialStatePropertyAll(20.0),
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
            bottomNavigationBar: CustomNavigationBar(
              
              iconSize: 26, 
              backgroundColor: Colors.white,
              selectedColor: Theme.of(context).primaryColorDark,
              strokeColor: Theme.of(context).primaryColorDark,
              borderRadius: const Radius.circular(20),
              elevation: 20,
              bubbleCurve: Curves.easeInOut,
              currentIndex: index,
              onTap: (value) async {
                setState(() {
                  index = value;
                });
              },
              items: [
                CustomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(Icons.favorite_outline),
                  selectedIcon: const Icon(Icons.favorite),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  selectedIcon: const Icon(Icons.shopping_cart),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(Icons.account_circle_outlined),
                  selectedIcon: const Icon(Icons.account_circle),
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
