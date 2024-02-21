import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/models/product_model.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryIntialState());

  void clearCategoryItems() {
    emit(CategoryIntialState());
  }

  void setCategoryItems(List<Product> categoryProducts) {
    emit(CategoryLoadedState(categoryProducts));
  }

  void addCategoryItems(List<Product> newProducts) {
    if (state is CategoryLoadedState) {
      final List<Product> currentProducts =
          (state as CategoryLoadedState).categoryProducts;
      final List<Product> updatedProducts = List.from(currentProducts)
        ..addAll(newProducts);
      emit(CategoryLoadedState(updatedProducts));
    }
  }

  void setCatgeoryToEndfetch(List<Product> categoryProducts) {
    emit(CategoryLoadedToEndState(categoryProducts));
  }
}

abstract class CategoryState {}

class CategoryIntialState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  List<Product> categoryProducts;

  CategoryLoadedState(this.categoryProducts);
}

class CategoryLoadedToEndState extends CategoryState {
  List<Product> categoryProducts;

  CategoryLoadedToEndState(this.categoryProducts);
}
