import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/models/order_model.dart';

class ShoppingCartCubit extends Cubit<ShoppingCartState> {
  ShoppingCartCubit() : super(ShoppingCartInitialState());

  List<OrderItem> loadItems() {
    if (state is ShoppingCartLoadedState) {
      return (state as ShoppingCartLoadedState).shoppingCartList;
    } else {
      return [];
    }
  }

  void updateShoppingCart(List<OrderItem> shoppingCartList) {
    emit(ShoppingCartLoadedState(shoppingCartList));
  }

  void clearShoppingList() {
    emit(ShoppingCartLoadedState([]));
    
  }

  void addItemToCart(
    OrderItem newItem,
  ) {
    if (state is ShoppingCartLoadedState) {
      final currentShoppingCartList =
          (state as ShoppingCartLoadedState).shoppingCartList;

      final existingItemIndex = currentShoppingCartList
          .indexWhere((item) => item.productId == newItem.productId);

      final updatedShoppingCartList =
          List<OrderItem>.from(currentShoppingCartList);

      if (existingItemIndex != -1) {
        // Product already exists, update quantity
        updatedShoppingCartList[existingItemIndex] = OrderItem(
          productId: newItem.productId,
          productName: newItem.productName,
          quantity: updatedShoppingCartList[existingItemIndex].quantity +
              newItem.quantity,
          price: newItem.price,
        );
      } else {
        // Product does not exist, add it to the list
        updatedShoppingCartList.add(newItem);
      }

      emit(ShoppingCartLoadedState(updatedShoppingCartList));
    } else {
      // If the shopping cart is not loaded yet, add the item directly
      emit(ShoppingCartLoadedState([newItem]));
    }
  }

  void incrementQuantity(OrderItem item) {
    if (state is ShoppingCartLoadedState) {
      final currentShoppingCartList =
          (state as ShoppingCartLoadedState).shoppingCartList;

      final updatedShoppingCartList =
          List<OrderItem>.from(currentShoppingCartList);

      final existingItemIndex = updatedShoppingCartList.indexWhere(
          (existingItem) => existingItem.productId == item.productId);

      if (existingItemIndex != -1) {
        updatedShoppingCartList[existingItemIndex] = OrderItem(
          productId: item.productId,
          productName: item.productName,
          quantity: item.quantity + 1,
          price: item.price,
        );

        emit(ShoppingCartLoadedState(updatedShoppingCartList));
      }
    }
  }

  // Method to decrement the quantity of a specific item in the shopping cart
  void decrementQuantity(OrderItem item) {
    if (state is ShoppingCartLoadedState) {
      final currentShoppingCartList =
          (state as ShoppingCartLoadedState).shoppingCartList;

      final updatedShoppingCartList =
          List<OrderItem>.from(currentShoppingCartList);

      final existingItemIndex = updatedShoppingCartList.indexWhere(
          (existingItem) => existingItem.productId == item.productId);

      if (existingItemIndex != -1 &&
          updatedShoppingCartList[existingItemIndex].quantity > 1) {
        updatedShoppingCartList[existingItemIndex] = OrderItem(
          productId: item.productId,
          productName: item.productName,
          quantity: item.quantity - 1,
          price: item.price,
        );

        emit(ShoppingCartLoadedState(updatedShoppingCartList));
      }
    }
  }

  void deleteItem(OrderItem item) {
    if (state is ShoppingCartLoadedState) {
      final currentShoppingCartList =
          (state as ShoppingCartLoadedState).shoppingCartList;

      final updatedShoppingCartList =
          List<OrderItem>.from(currentShoppingCartList);

      final existingItemIndex = updatedShoppingCartList.indexWhere(
          (existingItem) => existingItem.productId == item.productId);

      if (existingItemIndex != -1) {
        updatedShoppingCartList.removeAt(existingItemIndex);
        emit(ShoppingCartLoadedState(updatedShoppingCartList));
      }
    }
  }
}

abstract class ShoppingCartState {}

class ShoppingCartInitialState extends ShoppingCartState {}

class ShoppingCartLoadedState extends ShoppingCartState {
  final List<OrderItem> shoppingCartList;

  ShoppingCartLoadedState(this.shoppingCartList);
}
