part of 'sales_bloc.dart';

abstract class SalesState extends Equatable {
  const SalesState();

  @override
  List<Object?> get props => [];
}

final class SalesInitial extends SalesState {}

final class SalesLoading extends SalesState {}

final class SalesError extends SalesState {
  final String errorMessage;

  SalesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class SalesLoaded extends SalesState {
  final List<OrderModel> orders;
  final double totalRevenue;
  final int totalOrders;
  final Map<DateTime, double> revenueTimeline;
  final DateTime? fromDate;
  final DateTime? toDate;

  SalesLoaded({
    required this.totalRevenue,
    required this.totalOrders,
    required this.revenueTimeline,
    required this.orders,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [
        totalRevenue,
        totalOrders,
        revenueTimeline,
        orders,
        fromDate,
        toDate,
      ];
}
