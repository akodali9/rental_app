import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/auth_page.dart';
import 'package:rental_app/Auth/provider/auth_switch.dart';
import 'package:rental_app/routes/routes.dart';
import 'package:rental_app/screens/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthSwitchCubit(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            // colorSchemeSeed: Colors.black,
            colorSchemeSeed: const Color.fromARGB(255, 130, 219, 255),
            // bottomNavigationBarTheme:
            //     BottomNavigationBarThemeData(backgroundColor: Colors.white),
          ),
          title: "Rental App",
          onGenerateRoute: (routeSettings) => generateRoutes(routeSettings),
          initialRoute: '/',
          routes: {
            '/': (_) => const HomePage(),
            '/auth': (_) => const AuthPage(),
          },
        ),
      ),
    ),
  );
}
