import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/models/user_model.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState());

  void setUser(UserModel user) {
    emit(UserLoadedState(user));
  }
}

abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoadedState extends UserState {
  final UserModel user;

  UserLoadedState(this.user);
}