import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/models/user_model.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState()) {
    // Set the guest user after the initial state
    setUser(guestUser());
  }

  UserModel guestUser() {
    return UserModel(
      userId: 'guestUserId',
      name: 'Guest User',
      email: 'guest@example.com',
      isAdmin: false,
      favoriteProducts: [],
      addressList: [],
      ordersList: [],
    );
  }

  void setUser(UserModel user) {
    emit(UserLoadedState(user));
  }

  void removeUser(){
    setUser(guestUser());
  }

  UserModel getCurrentUser() {
    if (state is UserLoadedState) {
      return (state as UserLoadedState).user;
    }
    return guestUser();
  }
}

abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoadedState extends UserState {
  final UserModel user;

  UserLoadedState(this.user);
}
