import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rental_app/models/user_model.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState()) {
    // Set the guest user after the initial state
    loadUser();
  }

  Future<void> setUser(UserModel user) async {
    try {
      final userJson = user.toJson();

      await secureStorage.write(key: 'user', value: userJson);

      emit(UserLoadedState(user));
    } catch (error) {
      print('Error saving user data: $error');
    }
  }

  Future<void> loadUser() async {
    try {
      final userJson = await secureStorage.read(key: 'user');

      if (userJson != null) {
        final user = UserModel.fromJson(userJson);

        setUser(user);
      }
    } catch (error) {
      print('Error loading user data: $error');
    }
  }

  void removeUser() {
    secureStorage.delete(key: 'user');
    secureStorage.delete(key: 'usertoken');
    emit(UserInitialState());
  }

  Future<void> toggleFavoriteProduct(String productId) async {
    try {
      if (state is UserLoadedState) {
        final UserModel user = (state as UserLoadedState).user;

        // Toggle favorite status in the user model
        user.toggleFavoriteProduct(productId);

        // Save the updated user data
        await setUser(user);

        emit(UserLoadedState(user)); // Emit the updated state
      }
    } catch (error) {
      print('Error toggling favorite product: $error');
    }
  }
}

abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoadedState extends UserState {
  final UserModel user;

  UserLoadedState(this.user);
}
