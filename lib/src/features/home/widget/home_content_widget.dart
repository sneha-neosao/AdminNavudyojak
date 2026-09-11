import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../notifications/bloc/notifications_count_bloc/notifications_count_bloc.dart';
import '../../widgets/app_snackbar_widget.dart';
import '../bloc/admin_dashboard_bloc/admin_dashboard_bloc.dart';
import '../../../remote/models/dashboard_model/admin_dashboard_response.dart';
import 'cockpit_card_widget.dart';
import 'home_metric_item.dart';
import 'home_metrics_grid_widget.dart';
import 'home_top_bar_widget.dart';
import 'new_customer_item.dart';
import 'new_customers_card_widget.dart';
import 'return_settlement_card_widget.dart';
import 'return_settlement_item.dart';
import 'weekly_movement_card_widget.dart';

class HomeContentWidget extends StatefulWidget {
  const HomeContentWidget({super.key});

  @override
  State<HomeContentWidget> createState() => _HomeContentWidgetState();
}

class _HomeContentWidgetState extends State<HomeContentWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminDashboardBloc, AdminDashboardState>(
      listener: (context, state) {
        if (state is AdminDashboardFailureState) {
          AppSnackBarWidget.show(
            context,
            message: state.message,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state is AdminDashboardLoadingState ||
            state is AdminDashboardInitialState;
        if (state is AdminDashboardFailureState) {
          return _buildErrorState(context, state.message);
        }

        AdminDashboardData? data;
        bool isChangingPeriod = false;
        String currentPeriod = 'this_week';
        if (state is AdminDashboardSuccessState) {
          data = state.data.data;
          isChangingPeriod = state.isChangingPeriod;
          currentPeriod = state.currentPeriod;
        }

        // Map metrics
        final metrics = data?.metrics;
        final List<HomeMetricItem> metricItems = [
          HomeMetricItem(
            value: metrics?.sales?.formattedValue ?? '₹0',
            label: metrics?.sales?.title ?? 'Sales',
            subtext: metrics?.sales?.trendPercentage != null
                ? '+${metrics!.sales!.trendPercentage}%'
                : '0%',
            icon: Icons.currency_rupee_rounded,
          ),
          HomeMetricItem(
            value: metrics?.purchases?.formattedValue ?? '₹0',
            label: metrics?.purchases?.title ?? 'Purchases',
            subtext: '${metrics?.purchases?.billsCount ?? 0} bills',
            icon: Icons.receipt_long_outlined,
          ),
          HomeMetricItem(
            value: metrics?.rawMaterial?.formattedValue ?? '₹0',
            label: metrics?.rawMaterial?.title ?? 'Raw material',
            subtext:
                '${metrics?.rawMaterial?.availablePercentage ?? 0}% available',
            icon: Icons.category_outlined,
          ),
          HomeMetricItem(
            value: metrics?.finishedProducts?.formattedValue ?? '0',
            label: metrics?.finishedProducts?.title ?? 'Finished products',
            subtext: 'units ready',
            icon: Icons.inventory_2_outlined,
          ),
          HomeMetricItem(
            value: metrics?.customers?.formattedValue ?? '0',
            label: metrics?.customers?.title ?? 'Customers',
            subtext: '+${metrics?.customers?.newThisWeekCount ?? 0} this week',
            icon: Icons.people_outline_rounded,
          ),
          HomeMetricItem(
            value: metrics?.expenses?.formattedValue ?? '₹0',
            label: metrics?.expenses?.title ?? 'Expenses',
            subtext: '${metrics?.expenses?.percentageOfSales ?? 0}% of sales',
            icon: Icons.factory_outlined,
          ),
        ];

        // Map return settlements
        final List<ReturnSettlementItem> returnSettlementItems =
            (data?.returnSettlements?.items ?? []).map((item) {
              return ReturnSettlementItem(
                name: item.name ?? item.customerName ?? 'Customer',
                code: item.code ?? 'RET',
                description: item.description ?? '',
                amount: item.formattedAmount ?? item.amount ?? '₹0',
              );
            }).toList();

        // Map new customers
        final List<NewCustomerItem>
        customerItems = (data?.newCustomers?.items ?? []).map((customer) {
          return NewCustomerItem(
            initials: customer.initials?.isNotEmpty == true
                ? customer.initials!
                : (customer.fullName?.isNotEmpty == true
                      ? customer.fullName![0]
                      : 'C'),
            name: customer.fullName ?? 'Customer',
            subtitle:
                customer.locationTimeLabel ??
                '${customer.cityName ?? ''} · ${customer.relativeTime ?? ''}',
            amount:
                customer.formattedLifetimeValue ??
                '₹${customer.lifetimeValue ?? 0}',
          );
        }).toList();

        return RefreshIndicator(
          color: AppColor.cockpitOrange,
          backgroundColor: AppColor.pureWhite,
          onRefresh: () async {
            context.read<AdminDashboardBloc>().add(
              const RefreshAdminDashboardEvent(),
            );
            context.read<NotificationsCountBloc>().add(
              const RefreshNotificationsCountEvent(),
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Skeletonizer(
              enabled: isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.hS,
                  const HomeTopBarWidget(),
                  16.hS,
                  CockpitCardWidget(
                    userName: isLoading ? 'Owner' : data?.header?.userName,
                    dateText:
                        data?.header?.dateFormatted ??
                        'Friday, 11 September 2026',
                    alertText:
                        '${data?.header?.urgentAlertsCount ?? 0} urgent alerts',
                  ),
                  16.hS,
                  HomeMetricsGridWidget(
                    items: isLoading
                        ? HomeMetricsGridWidget.defaultMetrics
                        : metricItems,
                  ),
                  16.hS,
                  WeeklyMovementCardWidget(
                    salesValue: (isLoading || isChangingPeriod)
                        ? '₹2.7L'
                        : data
                                  ?.businessMovement
                                  ?.summary
                                  ?.sales
                                  ?.formattedValue ??
                              '₹0',
                    productionValue: (isLoading || isChangingPeriod)
                        ? '0'
                        : data
                                  ?.businessMovement
                                  ?.summary
                                  ?.production
                                  ?.formattedValue ??
                              '0',
                    expensesValue: (isLoading || isChangingPeriod)
                        ? '₹0'
                        : data
                                  ?.businessMovement
                                  ?.summary
                                  ?.expenses
                                  ?.formattedValue ??
                              '₹0',
                    dailyBreakdown: data?.businessMovement?.dailyBreakdown,
                    currentPeriod: currentPeriod,
                    isLoading: isChangingPeriod,
                    onPeriodChanged: (period) {
                      context.read<AdminDashboardBloc>().add(
                        ChangePeriodEvent(period),
                      );
                    },
                  ),
                  16.hS,
                  ReturnSettlementCardWidget(
                    pendingCount: data?.returnSettlements?.pendingCount,
                    items: isLoading
                        ? ReturnSettlementCardWidget.defaultItems
                        : returnSettlementItems,
                  ),
                  16.hS,
                  NewCustomersCardWidget(
                    newThisWeekCount: data?.newCustomers?.newThisWeekCount,
                    items: isLoading
                        ? NewCustomersCardWidget.defaultCustomers
                        : customerItems,
                  ),
                  24.hS,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48.sp,
                color: AppColor.brightRed,
              ),
              16.hS,
              Text(
                'Failed to load dashboard data',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black,
                ),
                softWrap: true,
              ),
              6.hS,
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  color: AppColor.textSecondary,
                ),
                softWrap: true,
              ),
              20.hS,
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AdminDashboardBloc>().add(
                    const GetAdminDashboardEvent(),
                  );
                  context.read<NotificationsCountBloc>().add(
                    const GetNotificationsCountEvent(),
                  );
                },
                icon: const Icon(Icons.refresh, color: AppColor.pureWhite),
                label: const Text(
                  'Retry',
                  style: TextStyle(
                    color: AppColor.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.cockpitOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
