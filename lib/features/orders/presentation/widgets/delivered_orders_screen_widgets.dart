import 'package:flutter/material.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/features/orders/presentation/screens/order_status_screen.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class DeliveredOrdersScreenWidgets {
  static Widget buildDeliveredOrdersList(List<OrderModel> orders) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final order = orders[index];
          final product = order.products[0];
          return GestureDetector(
            onTap: () => NavigationHelper.navigateToWithoutReplacement(
                context, ScreenOrderDetails(orderModel: order)),
            child: Container(
              padding: EdgeInsets.all(13),
              width: MediaQuery.of(context).size.width, // Full width
              decoration: BoxDecoration(
                color: AppColors.lightGreyThemeColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
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
                                value: loadingProgress.expectedTotalBytes !=
                                        null
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

                  SizedBox(width: 14),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getOrderStatusMessage(order.status),
                          style: AppTextStyles.titleMedium
                              .copyWith(color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${product.brandName} ${product.name}",
                                style: AppTextStyles.bodySmall
                                    .copyWith(color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: AppColors.greyThemeColor,
                            )
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "Order ID - ",
                              style: AppTextStyles.titleMedium.copyWith(
                                  color: Colors.black,
                                  fontSize: 14,
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(order.id.toUpperCase(),
                                style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.darkishGrey,
                                    fontSize: 14,
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)
                          ],
                        ),
                        SizedBox(height: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 18);
        },
        itemCount: orders.length);
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
