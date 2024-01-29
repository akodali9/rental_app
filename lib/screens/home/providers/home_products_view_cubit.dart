import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/models/product_model.dart';

class HomeProductViewCubit extends Cubit<HomeProductViewState> {
  HomeProductViewCubit() : super(HomeProductViewInitialState());

  List<Product> allFetchedProducts = [];

  List<Product> get allProducts => allFetchedProducts;

  void loadProducts(List<Product> newProducts) {
    // Append the new products to the existing list
    allFetchedProducts.addAll(newProducts);

    // Emit the loaded state with the updated list of all products
    emit(HomeProductViewLoadedState(allFetchedProducts));
  }

  void setIntialState(){
    emit(HomeProductViewInitialState());
  }

  void clearProducts() {
    allFetchedProducts = [];
    emit(HomeProductViewInitialState());
  }
}

abstract class HomeProductViewState {}

class HomeProductViewInitialState extends HomeProductViewState {}

class HomeProductViewLoadedState extends HomeProductViewState {
  List<Product> products;

  HomeProductViewLoadedState(this.products);
}
