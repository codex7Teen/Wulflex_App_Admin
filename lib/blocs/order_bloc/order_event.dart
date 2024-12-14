part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

//! FETCH ALL ORDERS EVENT
class FetchAllOrdersEvent extends OrderEvent {}

//! UPDATE ORDER EVENT
class UpdateOrderEvent extends OrderEvent {
  final String orderId;
  final OrderStatus newStatus;

  UpdateOrderEvent({required this.orderId, required this.newStatus});

  @override
  List<Object> get props => [orderId, newStatus];
}

//! FILTER ORDER BY STATUS EVENT
class FilterOrderByStatusEvent extends OrderEvent {
  final OrderStatus status;

  FilterOrderByStatusEvent({required this.status});
  @override
  List<Object> get props => [status];
}
