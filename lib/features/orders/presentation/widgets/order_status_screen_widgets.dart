import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/data/models/product_model.dart';

class OrderStatusScreenWidgets {
  static Widget buildAccountInformationtext() {
    return Text('ACCOUNT INFORMATION', style: AppTextStyles.screenSubHeading);
  }

  static Widget buildOrderId(OrderModel orderModel) {
    return Row(
      children: [
        Text("Order ID : ", style: AppTextStyles.miniTextBold),
        Text(orderModel.id.toUpperCase(), style: AppTextStyles.miniTextSimple)
      ],
    );
  }

  static Widget buildUserid(OrderModel orderModel) {
    return Row(
      children: [
        Text("User ID : ", style: AppTextStyles.miniTextBold),
        Text(orderModel.userId.toUpperCase(),
            style: AppTextStyles.miniTextSimple)
      ],
    );
  }

  static Widget buildOrderdate(String formattedDate) {
    return Row(
      children: [
        Text("Order Date : ", style: AppTextStyles.miniTextBold),
        Text(formattedDate, style: AppTextStyles.miniTextSimple)
      ],
    );
  }

  static Widget buildProductDetailsText() {
    return Text('PRODCUT DETAILS', style: AppTextStyles.screenSubHeading);
  }

  static Widget buildProductDetailsCard(
      BuildContext context, ProductModel product) {
    return Container(
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
                          "₹${NumberFormat('#,##,###.##').format(product.retailPrice)}",
                          style: AppTextStyles.itemCardSecondSubTitleText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "₹${NumberFormat('#,##,###.##').format(product.offerPrice)}",
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
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
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
          SizedBox(height: 8),
          Row(
            children: [
              Text('QUANTITY: ${product.quantity}',
                  style: AppTextStyles.orderQuantityText),
              Spacer(),
              Text(
                  product.selectedSize != null
                      ? 'SIZE: ${product.selectedSize}'
                      : 'WEIGHT: ${product.selectedWeight}',
                  style: AppTextStyles.orderQuantityText),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildDeliveryAddressText() {
    return Text('DELIVERY ADDRESS', style: AppTextStyles.screenSubHeading);
  }

  static Widget buildDeliveryAddress(OrderModel orderModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderModel.address.name,
                style: AppTextStyles.addressNameText,
              ),
              SizedBox(height: 10),
              Text(orderModel.address.houseName,
                  style: AppTextStyles.addressListItemsText),
              Text(
                  "${orderModel.address.areaName}, ${orderModel.address.cityName}",
                  style: AppTextStyles.addressListItemsText),
              Text(
                  "${orderModel.address.stateName}, ${orderModel.address.pincode}",
                  style: AppTextStyles.addressListItemsText),
              SizedBox(height: 10),
              Text("Phone: ${orderModel.address.phoneNumber}",
                  style: AppTextStyles.addressListItemsText),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  static Widget buildOrderStatustext() {
    return Text('MARK ORDER STATUS', style: AppTextStyles.screenSubHeading);
  }

  static Widget buildOrderStatusMarker(
      OrderStatus currentStatus, Function(OrderStatus?) onChanged) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGreyThemeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<OrderStatus>(
          value: currentStatus,
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
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Order status string helper
  static String _getOrderStatusMessage(OrderStatus status) {
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
