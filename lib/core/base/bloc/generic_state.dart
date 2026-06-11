import 'package:equatable/equatable.dart';

abstract class GenericState<T> extends Equatable {
  const GenericState(this.data, {this.changed = false});
  final T data;
  final bool changed;

  @override
  List<Object?> get props => [data, changed];
}

class GenericInitialState<T> extends GenericState<T> {
  const GenericInitialState(super.data);

  @override
  List<Object?> get props => [data, changed];
}

class GenericUpdateState<T> extends GenericState<T> {
  const GenericUpdateState(super.data, {super.changed});

  @override
  List<Object?> get props => [data, changed];
}