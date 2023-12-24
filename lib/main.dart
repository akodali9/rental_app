import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rental_app/routes/routes.dart';
import 'package:rental_app/main_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          // colorSchemeSeed: Color.fromARGB(255, 187, 251, 152),
          // scaffoldBackgroundColor: Colors.white,
          colorSchemeSeed: const Color.fromARGB(255, 130, 219, 255),
          // bottomNavigationBarTheme:
          //     BottomNavigationBarThemeData(backgroundColor: Colors.white),
        ),
        title: "Rental App",
        onGenerateRoute: (routeSettings) => generateRoutes(routeSettings),
        initialRoute: '/',
        home:  MainApp(),
      ),
    ),
  );
}
