import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/snackbar_showtext.dart';

void logoutuser(BuildContext context) {
  UserCubit user = context.read<UserCubit>();
  user.removeUser();
  showSnackbar(context, "Session expired\nPlease Login again!");
}
