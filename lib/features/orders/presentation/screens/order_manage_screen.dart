import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/orders/bloc/order_bloc/order_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/orders/presentation/widgets/order_manage_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';

class ScreenOrderManage extends StatelessWidget {
  const ScreenOrderManage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(FetchAllOrdersEvent());
    return Scaffold(
        backgroundColor: AppColors.whiteThemeColor,
        appBar: AppbarWithbackbuttonWidget(appBarTitle: 'Manage Orders'),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderError) {
              return Center(child: Text('Error loading products'));
            } else if (state is OrderLoaded) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return Center(child: Text('Orders are empty'));
              }
              return Padding(
                padding: const EdgeInsets.all(18),
                child: OrderManageScreenWidgets.buildAllOrdersList(
                    context, orders),
              );
            }
            return Center(child: Text('Something went wrong'));
          },
        ));
  }
}
