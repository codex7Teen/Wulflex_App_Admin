import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/features/products/bloc/sales_bloc/sales_bloc.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';

class ScreenSalesDashboardScreen extends StatefulWidget {
  const ScreenSalesDashboardScreen({super.key});

  @override
  ScreenSalesDashboardScreenState createState() =>
      ScreenSalesDashboardScreenState();
}

class ScreenSalesDashboardScreenState
    extends State<ScreenSalesDashboardScreen> {
  bool isDaily = true;

  @override
  void initState() {
    super.initState();
    context.read<SalesBloc>().add(FetchSalesData(isDaily: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppbarWithbackbuttonWidget(appBarTitle: 'Revenue & Sales'),
      body: BlocBuilder<SalesBloc, SalesState>(
        builder: (context, state) {
          if (state is SalesLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is SalesError) {
            return Center(child: Text(state.errorMessage));
          }
          if (state is SalesLoaded) {
            return _buildContent(state);
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(SalesLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle buttons
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(
                  'Daily',
                  style: AppTextStyles.screenSubHeading.copyWith(
                      color: isDaily
                          ? AppColors.whiteThemeColor
                          : AppColors.blackThemeColor),
                ),
              ),
              ButtonSegment(
                value: false,
                label: Text(
                  'Monthly',
                  style: AppTextStyles.screenSubHeading.copyWith(
                      color: isDaily
                          ? AppColors.blackThemeColor
                          : AppColors.whiteThemeColor),
                ),
              ),
            ],
            selected: {isDaily},
            onSelectionChanged: (Set<bool> newSelection) {
              setState(() {
                isDaily = newSelection.first;
                context.read<SalesBloc>().add(FetchSalesData(isDaily: isDaily));
              });
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.blueThemeColor; // Selected background color
                }
                return Colors.grey.shade200; // Default background color
              }),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
              ),
              elevation:
                  WidgetStateProperty.all(4.0), // Add shadow for smoothness
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Key metrics
          _buildMetricCard(
            'Total Revenue',
            '₹${NumberFormat('#,##,###.##').format(state.totalRevenue)}',
            Icons.currency_rupee,
          ),
          SizedBox(height: 16),
          _buildMetricCard(
            'Total Orders',
            state.totalOrders.toString(),
            Icons.shopping_cart,
          ),

          // Revenue chart
          SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: _buildRevenueChart(state.revenueTimeline),
          ),

          // Transactions list
          SizedBox(height: 24),
          Text('Recent Transactions', style: AppTextStyles.screenSubHeading),
          SizedBox(height: 16),
          _buildTransactionsList(state.orders),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.revenueMetricsTotalText),
                Text(value, style: AppTextStyles.revenueMetricsValueText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(Map<DateTime, double> timeline) {
    final entries = timeline.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '₹${value.toInt()}',
                    style: GoogleFonts.roboto(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: isDaily ? 1 : 2,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= entries.length) return SizedBox.shrink();
                final date = entries[value.toInt()].key;
                return Text(
                  isDaily ? '${date.hour}:00' : '${date.day}/${date.month}',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: entries
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                .toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 5,
                color: Theme.of(context).primaryColor,
                strokeColor: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
        ],
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            left: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList(List<OrderModel> orders) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          title: Text('Order #${order.id}',
              style: AppTextStyles.revenueSectionOrderIdText),
          subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate),
              style: AppTextStyles.revenueSectionOrderDateText),
          trailing: Text(
              '₹${NumberFormat('#,##,###.##').format(order.totalAmount)}',
              style: AppTextStyles.revenueSectionOrderIdText),
        );
      },
    );
  }
}
