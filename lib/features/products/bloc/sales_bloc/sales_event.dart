part of 'sales_bloc.dart';

abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object?> get props => [];
}

class FetchSalesData extends SalesEvent {
  final bool isDaily;
  final DateTime? fromDate;
  final DateTime? toDate;

  FetchSalesData(this.fromDate, this.toDate, {this.isDaily = true});

    @override
  List<Object?> get props => [isDaily, fromDate, toDate];
}