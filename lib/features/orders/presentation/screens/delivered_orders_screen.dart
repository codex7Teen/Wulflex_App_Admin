import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/orders/bloc/order_bloc/order_bloc.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/orders/presentation/widgets/delivered_orders_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';

class ScreenDeliveredOrders extends StatelessWidget {
  const ScreenDeliveredOrders({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<OrderBloc>()
        .add(FilterOrderByStatusEvent(status: OrderStatus.delivered));
    return Scaffold(
        backgroundColor: AppColors.whiteThemeColor,
        appBar: AppbarWithbackbuttonWidget(appBarTitle: 'Deliverd Orders'),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderError) {
              return Center(child: Text('Error loading products'));
            } else if (state is OrderLoaded) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return Center(child: Text("No delivered orders"));
              }
              return Padding(
                padding: const EdgeInsets.all(18),
                child: DeliveredOrdersScreenWidgets.buildDeliveredOrdersList(
                    orders),
              );
            }
            return Center(child: Text('Something went wrong'));
          },
        ));
  }
}
