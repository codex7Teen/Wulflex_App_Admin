import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/orders/bloc/order_bloc/order_bloc.dart';
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
                Text('ACCOUNT INFORMATION',
                    style: AppTextStyles.screenSubHeading),
                SizedBox(height: 2),
                Row(
                  children: [
                    Text("Order ID : ", style: AppTextStyles.miniTextBold),
                    Text(widget.orderModel.id.toUpperCase(),
                        style: AppTextStyles.miniTextSimple)
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Text("User ID : ", style: AppTextStyles.miniTextBold),
                    Text(widget.orderModel.userId.toUpperCase(),
                        style: AppTextStyles.miniTextSimple)
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Text("Order Date : ", style: AppTextStyles.miniTextBold),
                    Text(formattedDate, style: AppTextStyles.miniTextSimple)
                  ],
                ),
                SizedBox(height: 5),
                Divider(color: AppColors.xtraLightGreyThemeColor),
                SizedBox(height: 5),
                Text('PRODCUT DETAILS', style: AppTextStyles.screenSubHeading),
                SizedBox(height: 2),
                Container(
                  padding: EdgeInsets.all(13),
                  width: MediaQuery.of(context).size.width, // Full width
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyThemeColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.brandName,
                                  style: AppTextStyles.itemCardBrandText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  product.name,
                                  style: AppTextStyles.itemCardNameText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 13),
                                Row(
                                  children: [
                                    Text(
                                      "₹${product.retailPrice.round()}",
                                      style: AppTextStyles
                                          .itemCardSecondSubTitleText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "₹${product.offerPrice.round()}",
                                      style: AppTextStyles.itemCardSubTitleText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 14),
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 84, // Fixed height
                              width: MediaQuery.of(context).size.width * 0.21,
                              child: Image.network(
                                product.imageUrls[0],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/wulflex_logo_nobg.png'),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: SizedBox(
                                      width: 26,
                                      height: 26,
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      //!xxxxxxxxxxxxxxx
                      SizedBox(height: 8),
                      Text('QUANTITY: ${product.quantity}',
                          style: AppTextStyles.orderQuantityText),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Divider(color: AppColors.xtraLightGreyThemeColor),
                Text('DELIVERY ADDRESS', style: AppTextStyles.screenSubHeading),
                SizedBox(height: 2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.orderModel.address.name,
                            style: AppTextStyles.addressNameText,
                          ),
                          SizedBox(height: 10),
                          Text(widget.orderModel.address.houseName,
                              style: AppTextStyles.addressListItemsText),
                          Text(
                              "${widget.orderModel.address.areaName}, ${widget.orderModel.address.cityName}",
                              style: AppTextStyles.addressListItemsText),
                          Text(
                              "${widget.orderModel.address.stateName}, ${widget.orderModel.address.pincode}",
                              style: AppTextStyles.addressListItemsText),
                          SizedBox(height: 10),
                          Text(
                              "Phone: ${widget.orderModel.address.phoneNumber}",
                              style: AppTextStyles.addressListItemsText),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Divider(color: AppColors.xtraLightGreyThemeColor),
                Text('MARK ORDER STATUS',
                    style: AppTextStyles.screenSubHeading),
                SizedBox(height: 2),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyThemeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<OrderStatus>(
                      value: _currentStatus,
                      isExpanded: true,
                      style: AppTextStyles.miniTextSimple,
                      dropdownColor: AppColors.lightGreyThemeColor,
                      items: OrderStatus.values.map((OrderStatus status) {
                        return DropdownMenuItem<OrderStatus>(
                          value: status,
                          child: Text(
                            _getOrderStatusMessage(status),
                            style: AppTextStyles.miniTextBold,
                          ),
                        );
                      }).toList(),
                      onChanged: (OrderStatus? newStatus) {
                        if (newStatus != null) {
                          setState(() {
                            _currentStatus = newStatus;
                          });
                        }
                      },
                    ),
                  ),
                ),
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

  // Order status string helper
  String _getOrderStatusMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return "Order Recieved";
      case OrderStatus.processing:
        return "Order is processing...";
      case OrderStatus.shipped:
        return "On the way...";
      case OrderStatus.delivered:
        return "Delivered successfully";
      case OrderStatus.cancelled:
        return "Order Cancelled";
    }
  }
}
