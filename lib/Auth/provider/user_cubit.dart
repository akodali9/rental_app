import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rental_app/models/order_model.dart';
import 'package:rental_app/models/user_model.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState()) {
    // Set the user after the initial state
    loadUser();
  }

  Future<void> setUser(UserModel user) async {
    try {
      final userJson = user.toJson();

      await secureStorage.write(key: 'user', value: userJson);

      emit(UserLoadedState(user));
    } catch (error) {
      // print('Error saving user data: $error');
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
      // print('Error loading user data: $error');
    }
  }

  void removeUser() {
    secureStorage.delete(key: 'user');
    secureStorage.delete(key: 'usertoken');
    emit(UserInitialState());
  }

  Future<void> updateAddressListForUser(
      List<AddressModel> updatedAddressList) async {
    try {
      if (state is UserLoadedState) {
        final UserModel user = (state as UserLoadedState).user;

        // Update the address list in the user model
        UserModel updatedUser = UserModel(
          userId: user.userId,
          name: user.name,
          email: user.email,
          isAdmin: user.isAdmin,
          wishlistProducts: user.wishlistProducts,
          addressList: updatedAddressList,
          ordersList: user.ordersList,
          shoppingCartList: user.shoppingCartList,
        );

        // Save the updated user data
        await setUser(updatedUser);

        emit(UserLoadedState(updatedUser)); // Emit the updated state
      }
    } catch (error) {
      // Handle error, e.g., log it or show an error message
    }
  }

  Future<void> updateOrdersList(List<String> updatedOrdersList) async {
    try {
      if (state is UserLoadedState) {
        final UserModel user = (state as UserLoadedState).user;

        // Update the orders list in the user model
        UserModel updatedUser = UserModel(
          userId: user.userId,
          name: user.name,
          email: user.email,
          isAdmin: user.isAdmin,
          wishlistProducts: user.wishlistProducts,
          addressList: user.addressList,
          ordersList: updatedOrdersList,
          shoppingCartList: user.shoppingCartList,
        );

        // Save the updated user data
        await setUser(updatedUser);

        emit(UserLoadedState(updatedUser)); // Emit the updated state
      }
    } catch (error) {
      // Handle error, e.g., log it or show an error message
    }
  }

  Future<void> toggleWishlistProduct(String productId) async {
    try {
      if (state is UserLoadedState) {
        final UserModel user = (state as UserLoadedState).user;

        // Toggle favorite status in the user model
        user.toggleWishlistProduct(productId);

        // Save the updated user data
        await setUser(user);

        emit(UserLoadedState(user)); // Emit the updated state
      }
    } catch (error) {
      // print('Error toggling favorite product: $error');
    }
  }

  Future<void> updateShoppingCartListForUser(
      List<OrderItem> updatedShoppingCartList) async {
    try {
      if (state is UserLoadedState) {
        final UserModel user = (state as UserLoadedState).user;

        // Update the shopping cart list in the user model
        UserModel updatedUser = UserModel(
          userId: user.userId,
          name: user.name,
          email: user.email,
          isAdmin: user.isAdmin,
          wishlistProducts: user.wishlistProducts,
          addressList: user.addressList,
          ordersList: user.ordersList,
          shoppingCartList: updatedShoppingCartList,
        );

        // Save the updated user data
        await setUser(updatedUser);

        // emit(UserLoadedState(updatedUser)); // Emit the updated state
      }
    } catch (error) {
      // Handle error, e.g., log it or show an error message
    }
  }

  void clearShoppingCartList() async {
    if (state is UserLoadedState) {
      final UserModel user = (state as UserLoadedState).user;

      UserModel updatedUser = UserModel(
        userId: user.userId,
        name: user.name,
        email: user.email,
        isAdmin: user.isAdmin,
        wishlistProducts: user.wishlistProducts,
        addressList: user.addressList,
        ordersList: user.ordersList,
        shoppingCartList: [],
      );

      // Save the updated user data
      await setUser(updatedUser);
    }
  }
}

abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoadedState extends UserState {
  final UserModel user;

  UserLoadedState(this.user);
}
