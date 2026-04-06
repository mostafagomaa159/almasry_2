import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void changeBannerIndex(int index) {
    emit(state.copyWith(currentBannerIndex: index));
  }

  void changeOfferTab(int index) {
    emit(state.copyWith(selectedOfferTabIndex: index));
  }

  void changeBottomNavIndex(int index) {
    emit(state.copyWith(selectedBottomNavIndex: index));
  }
}
