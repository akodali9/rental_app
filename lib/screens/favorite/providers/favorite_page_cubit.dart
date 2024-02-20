import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/models/product_model.dart';

class FavoriteProductPageCubit extends Cubit<FavoriteProductPageState> {
  FavoriteProductPageCubit() : super(FavoriteProductPageInitialState());

  void loadFavoriteProducts(List<Product> favoriteProducts) {
    emit(FavoriteProductPageLoadedState(favoriteProducts));
  }

  void resetFavoriteProducts() {
    emit(FavoriteProductPageInitialState());
  }
}

abstract class FavoriteProductPageState {}

class FavoriteProductPageInitialState extends FavoriteProductPageState {}

class FavoriteProductPageEmptyState extends FavoriteProductPageState {}

class FavoriteProductPageLoadedState extends FavoriteProductPageState {
  List<Product> favoriteProducts;

  FavoriteProductPageLoadedState(this.favoriteProducts);
}
