import 'package:flutter_bloc/flutter_bloc.dart';

class CatgeoryFetched extends Cubit<CatgeoryFetchedState> {
  CatgeoryFetched() : super(CatgeoryFetchedInitialState());

  void setCategoryFetchedState(bool loaded) {
    emit(CatgeoryFetchedLoadedState(loaded));
  }

  void removeState() {
    emit(CatgeoryFetchedInitialState());
  }
}

abstract class CatgeoryFetchedState {}

class CatgeoryFetchedInitialState extends CatgeoryFetchedState {}

class CatgeoryFetchedLoadedState extends CatgeoryFetchedState {
  final bool loaded;
  CatgeoryFetchedLoadedState(this.loaded);
}
