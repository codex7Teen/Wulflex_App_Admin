import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/data/services/order_services.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final OrderServices _orderServices;
  SalesBloc(this._orderServices) : super(SalesInitial()) {
    //! FETCH SALES BLOC
    on<FetchSalesData>((event, emit) async {
      try {
        emit(SalesLoading());
        final orders = await _orderServices.fetchAllOrders();

        // Filter orders based on view type and date range
        final filteredOrders = _filterOrders(
          orders,
          event.isDaily,
          event.fromDate,
          event.toDate,
        );

        // Calculate metrics
        final totalRevenue = _calculateTotalRevenue(filteredOrders);
        final revenueTimeline = _generateRevenueTimeline(filteredOrders, event.isDaily);

        emit(SalesLoaded(
          totalRevenue: totalRevenue,
          totalOrders: filteredOrders.length,
          revenueTimeline: revenueTimeline,
          orders: filteredOrders,
          fromDate: event.fromDate,
          toDate: event.toDate,
        ));
        log('BLOC: SALES DATA FETCHED SUCCESS');
      } catch (error) {
        log('BLOC: SALES DATA FETCH ERROR!!!');
        emit(SalesError(errorMessage: error.toString()));
      }
    });
  }

  List<OrderModel> _filterOrders(
    List<OrderModel> orders,
    bool isDaily,
    DateTime? fromDate,
    DateTime? toDate,
  ) {
    if (fromDate != null && toDate != null) {
      // If date range is specified, filter by range
      return orders.where((order) {
        return order.orderDate.isAfter(fromDate.subtract(Duration(days: 1))) &&
            order.orderDate.isBefore(toDate.add(Duration(days: 1)));
      }).toList();
    }

    // If no date range specified, use original daily/monthly logic
    final now = DateTime.now();
    return orders.where((order) {
      if (isDaily) {
        return order.orderDate.day == now.day &&
            order.orderDate.month == now.month &&
            order.orderDate.year == now.year;
      } else {
        return order.orderDate.month == now.month &&
            order.orderDate.year == now.year;
      }
    }).toList();
  }

  double _calculateTotalRevenue(List<OrderModel> orders) {
    return orders.fold(0, (sum, order) => sum + order.totalAmount);
  }

  Map<DateTime, double> _generateRevenueTimeline(
      List<OrderModel> orders, bool isDaily) {
    final timeline = <DateTime, double>{};
    for (var order in orders) {
      final key = isDaily
          ? DateTime(order.orderDate.year, order.orderDate.month,
              order.orderDate.day, order.orderDate.hour)
          : DateTime(
              order.orderDate.year, order.orderDate.month, order.orderDate.day);

      timeline[key] = (timeline[key] ?? 0) + order.totalAmount;
    }
    return timeline;
  }
}
