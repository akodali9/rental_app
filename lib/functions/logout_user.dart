import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/show_toast.dart';

void logoutuser(BuildContext context) {
  context.read<UserCubit>().removeUser();
  showToast(context, "Session expired\nPlease Login again!");
}
