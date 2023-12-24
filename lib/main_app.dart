import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/screens/home/home_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static const String routename = '/';

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int index = 0;

  final List screens = const [
    HomePage(),
    Center(
      child: Text("Search page"),
    ),
    Center(
      child: Text("Rental Cart page"),
    ),
    Center(
      child: Text("Account page"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
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
