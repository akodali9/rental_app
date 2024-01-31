import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/models/product_model.dart';

class SearchedProductCubit extends Cubit<SearchedProductState> {
  SearchedProductCubit() : super(SearchedProductInititalState());
  void setSearchedProducts(List<Product> searchedProducts) {
    emit(SearchedProductLoadedState(searchedProducts));
  }

  void setSearchedLoadingState() {
    emit(SearchedProductloadingState());
  }

  void removeSearchedProducts() {
    emit(SearchedProductInititalState());
  }
}

abstract class SearchedProductState {}

class SearchedProductInititalState extends SearchedProductState {}

class SearchedProductloadingState extends SearchedProductState {}

class SearchedProductLoadedState extends SearchedProductState {
  List<Product> searchedProducts;

  SearchedProductLoadedState(this.searchedProducts);
}
