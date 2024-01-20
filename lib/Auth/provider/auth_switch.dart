import 'package:flutter_bloc/flutter_bloc.dart';

class AuthSwitchCubit extends Cubit<bool> {
  AuthSwitchCubit() : super(true);

  void changeBool() {
    emit(!state);
  }
}
