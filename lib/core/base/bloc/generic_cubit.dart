import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenericState<T> extends Equatable {
  final T data;

  const GenericState(this.data);

  @override
  List<Object?> get props => [data];
}

class GenericCubit<T> extends Cubit<GenericState<T>> {
  GenericCubit(T initialData) : super(GenericState<T>(initialData));

  void update(T newData) {
    emit(GenericState<T>(newData));
  }

  void reset(T newData) {
    emit(GenericState<T>(newData));
  }
}
