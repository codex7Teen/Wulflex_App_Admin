import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';

class ScreenOrderDetails extends StatelessWidget {
  final OrderModel orderModel;
  const ScreenOrderDetails({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightScaffoldColor,
      appBar: AppbarWithbackbuttonWidget(appBarTitle: 'Manage Orders Status'),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text('ACCOUNT INFORMATION',
                style: GoogleFonts.bebasNeue(
                    fontSize: 22,
                    color: AppColors.darkScaffoldColor,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text("Order ID - ${orderModel.id}")
          ],
        ),
      ),
    );
  }
}
