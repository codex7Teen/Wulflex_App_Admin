import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/orders/bloc/order_bloc/order_bloc.dart';
import 'package:wulflex_admin/features/orders/presentation/widgets/order_status_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';

class ScreenOrderDetails extends StatefulWidget {
  final OrderModel orderModel;
  const ScreenOrderDetails({super.key, required this.orderModel});

  @override
  State<ScreenOrderDetails> createState() => _ScreenOrderDetailsState();
}

class _ScreenOrderDetailsState extends State<ScreenOrderDetails> {
  late OrderStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.orderModel.status;
  }

  @override
  Widget build(BuildContext context) {
    // product
    final product = widget.orderModel.products[0];
    // Format the DateTime
    String formattedDate =
        DateFormat('dd/MM/yyyy  HH:mm').format(widget.orderModel.orderDate);
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppbarWithbackbuttonWidget(appBarTitle: 'Manage Orders Status'),
      body: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderUpdateSuccess) {
            CustomSnackbar.showCustomSnackBar(
                context, "Order status updated success... 🎉🎉🎉");
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderStatusScreenWidgets.buildAccountInformationtext(),
                SizedBox(height: 2),
                OrderStatusScreenWidgets.buildOrderId(widget.orderModel),
                SizedBox(height: 2),
                OrderStatusScreenWidgets.buildUserid(widget.orderModel),
                SizedBox(height: 2),
                OrderStatusScreenWidgets.buildOrderdate(formattedDate),
                SizedBox(height: 5),
                Divider(color: AppColors.xtraLightGreyThemeColor),
                SizedBox(height: 5),
                OrderStatusScreenWidgets.buildProductDetailsText(),
                SizedBox(height: 2),
                OrderStatusScreenWidgets.buildProductDetailsCard(
                    context, product),
                SizedBox(height: 7),
                Divider(color: AppColors.xtraLightGreyThemeColor),
                OrderStatusScreenWidgets.buildDeliveryAddressText(),
                SizedBox(height: 2),
                OrderStatusScreenWidgets.buildDeliveryAddress(
                    widget.orderModel),
                SizedBox(height: 7),
                Divider(color: AppColors.xtraLightGreyThemeColor),
                OrderStatusScreenWidgets.buildOrderStatustext(),
                SizedBox(height: 2),
                OrderStatusScreenWidgets.buildOrderStatusMarker(_currentStatus,
                    (OrderStatus? newStatus) {
                  if (newStatus != null) {
                    setState(() {
                      _currentStatus = newStatus;
                    });
                  }
                }),
                SizedBox(height: 20),
                BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    return BlueButtonWidget(
                        isLoading: state is OrderLoading,
                        onTap: () {
                          context.read<OrderBloc>().add(UpdateOrderEvent(
                              orderId: widget.orderModel.id,
                              newStatus: _currentStatus));
                        },
                        buttonText: 'Update Order');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
