import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';
import '../bloc/business_performance_bloc/business_performance_bloc.dart';
import 'analytics_header_widget.dart';
import 'analytics_metrics_row_widget.dart';
import 'owner_scorecard_card_widget.dart';
import 'revenue_margin_card_widget.dart';

class AnalyticsContentWidget extends StatelessWidget {
  const AnalyticsContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessPerformanceBloc, BusinessPerformanceState>(
      listener: (context, state) {
        if (state is BusinessPerformanceFailureState) {
          AppSnackBarWidget.show(
            context,
            message: state.message,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is BusinessPerformanceLoadingState;
        final isFailure = state is BusinessPerformanceFailureState;
        final data =
            state is BusinessPerformanceSuccessState ? state.data.data : null;

        return RefreshIndicator(
          color: AppColor.cockpitOrange,
          backgroundColor: AppColor.pureWhite,
          onRefresh: () async {
            context
                .read<BusinessPerformanceBloc>()
                .add(const RefreshBusinessPerformanceEvent());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.hS,
                const AnalyticsHeaderWidget(),
                16.hS,
                if (isFailure && data == null)
                  _buildErrorCard(context, state.message)
                else ...[
                  AnalyticsMetricsRowWidget(
                    summaryCards: data?.summaryCards,
                    isLoading: isLoading,
                  ),
                  16.hS,
                  RevenueMarginCardWidget(
                    data: data?.revenueAndMargin,
                    isLoading: isLoading,
                  ),
                  16.hS,
                  OwnerScorecardCardWidget(
                    items: data?.ownerScorecard,
                    isLoading: isLoading,
                  ),
                  24.hS,
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
      child: Center(
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
              'Failed to load analytics',
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
                context
                    .read<BusinessPerformanceBloc>()
                    .add(const GetBusinessPerformanceEvent());
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
    );
  }
}
