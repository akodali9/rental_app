import 'package:flutter/material.dart';
import 'package:rental_app/main_app.dart';
import 'package:rental_app/screens/home/home_page.dart';

Route<dynamic> generateRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MainApp.routename:
      return MaterialPageRoute(
        builder: (_) => const MainApp(),
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
