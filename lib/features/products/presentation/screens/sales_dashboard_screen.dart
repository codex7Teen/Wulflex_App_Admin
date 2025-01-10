import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/products/bloc/sales_bloc/sales_bloc.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/features/products/presentation/widgets/sales_dashboard_screen_widgets.dart';
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
            if (fromDate != null && toDate != null)
              SalesDashboardScreenWidgets.buildDateRangeIndicator(context,
                  fromDate: fromDate, toDate: toDate, onPressed: () {
                setState(() {
                  fromDate = null;
                  toDate = null;
                });
                context
                    .read<SalesBloc>()
                    .add(FetchSalesData(isDaily: isDaily, fromDate, toDate));
              }),
            const SizedBox(height: 24),
            SalesDashboardScreenWidgets.buildMetricsSection(state),
            const SizedBox(height: 24),
            SalesDashboardScreenWidgets.buildChartSection(state, isDaily),
            const SizedBox(height: 24),
            SalesDashboardScreenWidgets.buildTransactionsList(state.orders),
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
}
