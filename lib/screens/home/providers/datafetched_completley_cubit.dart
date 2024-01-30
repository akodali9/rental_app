import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDataFetchedCubit extends Cubit<HomeDataFetchState> {
  HomeDataFetchedCubit() : super(HomeDataFetchInitialState());

  void trueStatus() {
    emit(HomeDataFetchLoadedState(true));
  }

  void falseStatus() {
    emit(HomeDataFetchInitialState());
  }
}

abstract class HomeDataFetchState {}

class HomeDataFetchInitialState extends HomeDataFetchState {}

class HomeDataFetchLoadedState extends HomeDataFetchState {
  final bool status;

  HomeDataFetchLoadedState(this.status);
}
