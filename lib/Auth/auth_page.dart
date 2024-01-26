import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/pages/account_login.dart';
import 'package:rental_app/Auth/pages/account_signup.dart';
import 'package:rental_app/Auth/provider/auth_switch.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final authSwitchCubit = BlocProvider.of<AuthSwitchCubit>(context);
    
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<AuthSwitchCubit, bool>(
        builder: (context, state) => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: Center(
              child: authSwitchCubit.state
                  ? Signup(
                      authSwitchCubit: authSwitchCubit,
                    )
                  : Login(
                      authSwitchCubit: authSwitchCubit,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
