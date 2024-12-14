part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderLoaded extends OrderState {
  final List<OrderModel> orders;

  OrderLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

final class OrderError extends OrderState {
  final String errorMessage;

  OrderError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
