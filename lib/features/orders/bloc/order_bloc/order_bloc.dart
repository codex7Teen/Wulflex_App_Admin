import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/data/services/order_services.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderServices _orderServices;
  OrderBloc(this._orderServices) : super(OrderInitial()) {
    //! FETCH ALL ORDERS BLOC
    on<FetchAllOrdersEvent>((event, emit) async {
      try {
        emit(OrderLoading());
        final orders = await _orderServices.fetchAllOrders();
        emit(OrderLoaded(orders: orders));
      } catch (error) {
        emit(OrderError(errorMessage: error.toString()));
      }
    });

    //! UPDATE ORDER STATUS
    on<UpdateOrderEvent>((event, emit) async {
      try {
        emit(OrderLoading());
        await _orderServices.updateOrderStatus(
            orderId: event.orderId, newStatus: event.newStatus);

        // Reflect all orders to get updated list
        final orders = await _orderServices.fetchAllOrders();
        // First emit the success state
        emit(OrderUpdateSuccess());

        // Use a Timer to delay the transition to OrderLoaded
        await Future.delayed(
          Duration(milliseconds: 500),
          () {
            emit(OrderLoaded(orders: orders));
          },
        );
      } catch (error) {
        emit(OrderError(errorMessage: error.toString()));
      }
    });

    //! FILTER ORDERS BY STATUS
    on<FilterOrderByStatusEvent>((event, emit) async {
      try {
        emit(OrderLoading());
        final orders = await _orderServices.filterOrdersByStatus(event.status);
        emit(OrderLoaded(orders: orders));
      } catch (error) {
        emit(OrderError(errorMessage: error.toString()));
      }
    });
  }
}
