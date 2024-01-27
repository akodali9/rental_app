import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/models/user_model.dart';
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
    UserCubit cubit = context.read<UserCubit>();

    final user = cubit.state;

    List screens = const [
      HomePage(),
      Center(
        child: Text("Favorite items page"),
      ),
      Center(
        child: Text("Checkout renatal cart page"),
      ),
      AccountPage(),
    ];
    return Scaffold(
      extendBody: true,
      body: screens[index],
      bottomNavigationBar: CustomNavigationBar(
        iconSize: 26,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedColor: Theme.of(context).primaryColor,
        strokeColor: Theme.of(context).primaryColor,
        // unSelectedColor: Theme.of(context).dividerColor,
        borderRadius: const Radius.circular(20),
        elevation: 20,
        bubbleCurve: Curves.easeInOut,
        currentIndex: index,
        onTap: (value) {
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
}
