import 'package:flutter/material.dart';
import 'package:rental_app/Auth/auth_page.dart';
import 'package:rental_app/main_extended.dart';
import 'package:rental_app/screens/home/home_page.dart';

Route<dynamic> generateRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MainAppExtended.routename:
      return MaterialPageRoute(
        builder: (_) => const MainAppExtended(),
        settings: routeSettings,
        maintainState: true,
      );
    case AuthPage.routename:
      return MaterialPageRoute(
        builder: (_) => const MainAppExtended(),
        settings: routeSettings,
        maintainState: true,
      );
    case HomePage.routename:
      return MaterialPageRoute(
        builder: (_) => const HomePage(),
        settings: routeSettings,
        maintainState: true,
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text(
              "Error 404",
            ),
          ),
        ),
      );
  }
}
