import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/models/product_model.dart';

class WishlistProductPageCubit extends Cubit<WishlistProductPageState> {
  WishlistProductPageCubit() : super(WishlistProductPageInitialState());

  void loadWishlistProducts(List<Product> WishlistProducts) {
    emit(WishlistProductPageLoadedState(WishlistProducts));
  }

  void resetWishlistProducts() {
    emit(WishlistProductPageInitialState());
  }
}

abstract class WishlistProductPageState {}

class WishlistProductPageInitialState extends WishlistProductPageState {}

class WishlistProductPageEmptyState extends WishlistProductPageState {}

class WishlistProductPageLoadedState extends WishlistProductPageState {
  List<Product> WishlistProducts;

  WishlistProductPageLoadedState(this.WishlistProducts);
}
