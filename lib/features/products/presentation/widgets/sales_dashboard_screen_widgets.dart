import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/features/products/bloc/sales_bloc/sales_bloc.dart';

class SalesDashboardScreenWidgets {
  static Widget buildTransactionsList(List<OrderModel> orders) {
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

  static Widget buildChartSection(SalesLoaded state, isDaily) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteThemeColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Timeline',
            style: AppTextStyles.revenueMetricsTotalText,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: _buildRevenueChart(state.revenueTimeline, isDaily),
          ),
        ],
      ),
    );
  }

  static Widget _buildRevenueChart(
      Map<DateTime, double> timeline, bool isDaily) {
    final entries = timeline.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No data available for the selected period',
          style: AppTextStyles.revenueMetricsValueText,
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey[100]!,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '₹${NumberFormat.compact().format(value)}',
                    style: GoogleFonts.roboto(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= entries.length) {
                  return const SizedBox.shrink();
                }
                final date = entries[value.toInt()].key;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    isDaily ? '${date.hour}:00' : '${date.day}/${date.month}',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
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
                AppColors.blueThemeColor,
                AppColors.blueThemeColor.withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 6,
                color: AppColors.blueThemeColor,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.blueThemeColor.withValues(alpha: 0.01),
                  AppColors.blueThemeColor..withValues(alpha: 0.01),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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

  static Widget buildMetricsSection(SalesLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: AppTextStyles.screenSubHeading,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Total Revenue',
                '₹${NumberFormat('#,##,###.##').format(state.totalRevenue)}',
                Icons.currency_rupee,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Total Orders',
                state.totalOrders.toString(),
                Icons.shopping_cart,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildMetricCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteThemeColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: AppColors.blueThemeColor),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.revenueMetricsTotalText),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.revenueMetricsValueText),
        ],
      ),
    );
  }

  static Widget buildDateRangeIndicator(BuildContext context,
      {required DateTime? fromDate, DateTime? toDate, Function()? onPressed}) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.blueThemeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blueThemeColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Date Range: ${DateFormat('dd/MM/yyyy').format(fromDate!)} - ${DateFormat('dd/MM/yyyy').format(toDate!)}',
              style: AppTextStyles.revenueMetricsValueText,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: onPressed,
            style: IconButton.styleFrom(
              foregroundColor: AppColors.blueThemeColor,
            ),
          ),
        ],
      ),
    );
  }
}
