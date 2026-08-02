import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenericCubit<T> extends Cubit<GenericState<T>> {
  GenericCubit(T data) : super(GenericInitialState<T>(data));

  void onUpdateData(T data) {
    emit(GenericUpdateState<T>(data, changed: !state.changed));
  }
}
