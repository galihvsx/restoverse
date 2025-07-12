import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

sealed class ApiState<T> extends Equatable {
  const ApiState();
  
  @override
  List<Object?> get props => [];
}

class ApiInitial<T> extends ApiState<T> {
  const ApiInitial();
}

class ApiLoading<T> extends ApiState<T> {
  const ApiLoading();
}

class ApiSuccess<T> extends ApiState<T> {
  final T data;
  const ApiSuccess(this.data);
  
  @override
  List<Object?> get props => [data];
}

class ApiError<T> extends ApiState<T> {
  final Failure failure;
  const ApiError(this.failure);
  
  @override
  List<Object?> get props => [failure];
}