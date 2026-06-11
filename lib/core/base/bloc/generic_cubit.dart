import 'package:almasry_2/core/base/bloc/generic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenericCubit<T> extends Cubit<GenericState<T>> {
  GenericCubit(T initialData) : super(GenericInitialState<T>(initialData));

  void update(T newData, {bool changed = true}) {
    emit(GenericUpdateState<T>(newData, changed: changed));
  }

  void reset(T newData) {
    emit(GenericInitialState<T>(newData));
  }
}
