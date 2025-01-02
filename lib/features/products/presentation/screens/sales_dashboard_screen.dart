import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/data/models/order_model.dart';
import 'package:wulflex_admin/features/products/bloc/sales_bloc/sales_bloc.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
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
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    context
        .read<SalesBloc>()
        .add(FetchSalesData(isDaily: true, fromDate, toDate));
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: fromDate != null && toDate != null
          ? DateTimeRange(start: fromDate!, end: toDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.blueThemeColor,
              onPrimary: AppColors.whiteThemeColor,
              onSurface: AppColors.blackThemeColor,
            ),
            textTheme: TextTheme(
              bodyMedium:
                  AppTextStyles.revenueMetricsTotalText, // Apply custom style
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
      });
      context.read<SalesBloc>().add(FetchSalesData(
            isDaily: isDaily,
            fromDate,
            toDate,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppbarWithbackbuttonWidget(appBarTitle: 'Revenue & Sales'),
      body: BlocBuilder<SalesBloc, SalesState>(
        builder: (context, state) {
          if (state is SalesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.blueThemeColor,
              ),
            );
          }
          if (state is SalesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.redThemeColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    // style: AppTextStyles.errorText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          if (state is SalesLoaded) {
            return _buildContent(state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(SalesLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<SalesBloc>()
            .add(FetchSalesData(isDaily: isDaily, fromDate, toDate));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            if (fromDate != null && toDate != null) _buildDateRangeIndicator(),
            const SizedBox(height: 24),
            _buildMetricsSection(state),
            const SizedBox(height: 24),
            _buildChartSection(state),
            const SizedBox(height: 24),
            _buildTransactionsList(state.orders),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(
                      'Daily',
                      style: AppTextStyles.screenSubHeading.copyWith(
                        color: isDaily
                            ? AppColors.whiteThemeColor
                            : AppColors.blackThemeColor,
                      ),
                    ),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(
                      'Monthly',
                      style: AppTextStyles.screenSubHeading.copyWith(
                        color: isDaily
                            ? AppColors.blackThemeColor
                            : AppColors.whiteThemeColor,
                      ),
                    ),
                  ),
                ],
                selected: {isDaily},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    isDaily = newSelection.first;
                    fromDate = null;
                    toDate = null;
                  });
                  context
                      .read<SalesBloc>()
                      .add(FetchSalesData(isDaily: isDaily, fromDate, toDate));
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.blueThemeColor;
                      }
                      return Colors.grey.shade200;
                    },
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  elevation: WidgetStatePropertyAll(4.0),
                  padding: WidgetStatePropertyAll(
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton.filled(
              onPressed: () => _selectDateRange(context),
              icon: const Icon(Icons.calendar_today),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.blueThemeColor,
                foregroundColor: AppColors.whiteThemeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateRangeIndicator() {
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
            onPressed: () {
              setState(() {
                fromDate = null;
                toDate = null;
              });
              context
                  .read<SalesBloc>()
                  .add(FetchSalesData(isDaily: isDaily, fromDate, toDate));
            },
            style: IconButton.styleFrom(
              foregroundColor: AppColors.blueThemeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(SalesLoaded state) {
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

  Widget _buildMetricCard(String title, String value, IconData icon) {
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

  Widget _buildChartSection(SalesLoaded state) {
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
            child: _buildRevenueChart(state.revenueTimeline),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(Map<DateTime, double> timeline) {
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
