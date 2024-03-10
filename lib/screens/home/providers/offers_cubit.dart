import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/offer_model.dart';

class OffersCubit extends Cubit<OfferState> {
  OffersCubit() : super(OfferInitialState());

  void setOfferList(List<Offer> offersList) {
    emit(OfferLoadedState(offersList));
  }

  void resetOfferList() {
    emit(OfferInitialState());
  }
}

class OfferState {}

class OfferInitialState extends OfferState {}

class OfferLoadedState extends OfferState {
  List<Offer> offerList;

  OfferLoadedState(this.offerList);
}
