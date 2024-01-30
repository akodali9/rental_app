import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rental_app/Auth/auth_page.dart';
import 'package:rental_app/Auth/provider/auth_switch.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/main_extended.dart';
import 'package:rental_app/models/product_model.dart';
import 'package:rental_app/routes/routes.dart';
import 'package:rental_app/screens/home/providers/datafetched_completley_cubit.dart';
import 'package:rental_app/screens/home/providers/home_products_view_cubit.dart';
import 'package:rental_app/screens/product_view_page/product_detailedView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(
      MultiBlocProvider(
        providers: [
          Provider<AuthSwitchCubit>(
            create: (_) => AuthSwitchCubit(),
            lazy: false,
          ),
          BlocProvider<UserCubit>(
            create: (_) => UserCubit(),
            lazy: false,
          ),
          BlocProvider<UserTokenCubit>(
            create: (_) => UserTokenCubit(),
            lazy: false,
          ),
          BlocProvider<HomeProductViewCubit>(
            create: (_) => HomeProductViewCubit(),
            lazy: false,
          ),BlocProvider<HomeDataFetchedCubit>(
            create: (_) => HomeDataFetchedCubit(),
            lazy: false,
          ),
        ],
        child: const MaterialAPP(),
      ),
    ),
  );
}

class MaterialAPP extends StatelessWidget {
  const MaterialAPP({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: '/',
      routes: {
        '/': (_) => const MainAppExtended(),
        '/auth': (_) => const AuthPage(),
      },
    );
  }
}
