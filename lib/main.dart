import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rental_app/Auth/auth_page.dart';
import 'package:rental_app/Auth/provider/auth_switch.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/main_app.dart';
import 'package:rental_app/routes/routes.dart';
import 'package:rental_app/screens/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(
      MultiProvider(
        providers: [
          Provider<AuthSwitchCubit>(
            create: (_) => AuthSwitchCubit(),
            lazy: false,
          ),
          BlocProvider<UserCubit>(
            create: (_) => UserCubit(),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
            brightness: Brightness.light,
            // colorSchemeSeed: Colors.black,
            colorSchemeSeed: const Color.fromARGB(255, 130, 219, 255),
            // bottomNavigationBarTheme:
            //     BottomNavigationBarThemeData(backgroundColor: Colors.white),
          ),
          title: "Rental App",
          onGenerateRoute: (routeSettings) => generateRoutes(routeSettings),
          initialRoute: '/auth',
          routes: {
            '/': (_) => const MainApp(),
            '/auth': (_) => const AuthPage(),
          },
        ),
      ),
    ),
  );
}
