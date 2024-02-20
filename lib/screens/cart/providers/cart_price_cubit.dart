import 'package:flutter_bloc/flutter_bloc.dart';

class CartPriceCubit extends Cubit<CartPriceState> {
  CartPriceCubit() : super(CartPriceInitialState()) {
    loadInitialPrice();
  }

  void loadInitialPrice() {
    emit(CartPriceLoadingState(0));
  }

  void loadComputedPrice(double totalCost) {
    emit(CartPriceLoadingState(totalCost));
  }
}

abstract class CartPriceState {}

class CartPriceInitialState extends CartPriceState {}

class CartPriceLoadingState extends CartPriceState {
  double totalCost;

  CartPriceLoadingState(this.totalCost);
}
