import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/bookings_model/pending_advance_bookings_response.dart';
import '../../../../routes/app_route_path.dart';
import '../../../widgets/app_snackbar_widget.dart';
import '../../bloc/approve_pending_advance_bloc/approve_pending_advance_bloc.dart';
import '../../bloc/pending_advance_bookings_bloc/pending_advance_bookings_bloc.dart';
import 'pending_advance_booking_card_widget.dart';
import 'pending_advance_bookings_header_widget.dart';

class PendingAdvanceBookingsContentWidget extends StatefulWidget {
  const PendingAdvanceBookingsContentWidget({super.key});

  @override
  State<PendingAdvanceBookingsContentWidget> createState() =>
      _PendingAdvanceBookingsContentWidgetState();
}

class _PendingAdvanceBookingsContentWidgetState
    extends State<PendingAdvanceBookingsContentWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= maxScroll - 150) {
        context
            .read<PendingAdvanceBookingsBloc>()
            .add(LoadMorePendingAdvanceBookingsEvent());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApprovePendingAdvanceBloc, ApprovePendingAdvanceState>(
      listener: (context, approveState) {
        if (approveState is ApprovePendingAdvanceSuccessState) {
          final msg = approveState.data.message?.isNotEmpty == true
              ? approveState.data.message!
              : 'Advance payment approved successfully';
          AppSnackBarWidget.show(
            context,
            message: msg,
            type: ToastType.success,
          );
          context
              .read<PendingAdvanceBookingsBloc>()
              .add(RefreshPendingAdvanceBookingsEvent());
        } else if (approveState is ApprovePendingAdvanceFailureState) {
          AppSnackBarWidget.show(
            context,
            message: approveState.message.isNotEmpty
                ? approveState.message
                : 'Failed to approve booking advance',
            type: ToastType.error,
          );
        }
      },
      builder: (context, approveState) {
        return BlocBuilder<PendingAdvanceBookingsBloc,
            PendingAdvanceBookingsState>(
          builder: (context, state) {
            final isLoading = state is PendingAdvanceBookingsLoadingState;
            final isFailure = state is PendingAdvanceBookingsFailureState;
            final isSuccess = state is PendingAdvanceBookingsSuccessState;

            final items =
                isSuccess ? state.allResults : <PendingAdvanceBookingItem>[];
            final totalCount = isSuccess
                ? (state.data.data?.pagination?.count ?? items.length)
                : 0;
            final isLoadingMore = isSuccess && state.isLoadingMore;

            return RefreshIndicator(
              color: AppColor.primary,
              backgroundColor: AppColor.pureWhite,
              onRefresh: () async {
                context
                    .read<PendingAdvanceBookingsBloc>()
                    .add(RefreshPendingAdvanceBookingsEvent());
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // Top padding
                  SliverToBoxAdapter(child: 8.hS),

                  // Header Widget
                  SliverToBoxAdapter(
                    child:
                        PendingAdvanceBookingsHeaderWidget(count: totalCount),
                  ),

                  SliverToBoxAdapter(child: 8.hS),

                  // 1. Initial Loading State using Skeletonizer
                  if (isLoading)
                    SliverToBoxAdapter(
                      child: Skeletonizer(
                        enabled: true,
                        child: Column(
                          children: List.generate(
                            5,
                            (_) => const PendingAdvanceBookingCardWidget(
                              item: PendingAdvanceBookingItem(
                                bookingId: 'BK-1-2026-148',
                                itemTitle: 'Diamond Supari Cutting Machine',
                                formattedTotalAmount: '₹3,32,500',
                                formattedPendingAdvanceAmount: '₹2,500',
                                createdAt: '2026-09-15T16:22:00.640697+05:30',
                                customer: PendingAdvanceCustomer(
                                  fullName: 'Customer Name',
                                  mobileNo: '9876543210',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  // 2. Error State with Retry
                  else if (isFailure)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 30.h,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 28.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.pureWhite,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColor.metricCardBorder,
                              width: 1.1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 46.sp,
                                color: AppColor.brightRed,
                              ),
                              12.hS,
                              Text(
                                state.message,
                                style: TextStyle(
                                  color: AppColor.charcoal,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                              16.hS,
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.primary,
                                  foregroundColor: AppColor.pureWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 18.w,
                                    vertical: 10.h,
                                  ),
                                ),
                                onPressed: () {
                                  context.read<PendingAdvanceBookingsBloc>().add(
                                        const GetPendingAdvanceBookingsEvent(),
                                      );
                                },
                                icon:
                                    const Icon(Icons.refresh_rounded, size: 18),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  // 3. Empty State (Rule 10)
                  else if (items.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 54.sp,
                                color:
                                    AppColor.slateGrey.withValues(alpha: 0.6),
                              ),
                              14.hS,
                              Text(
                                'No Pending Advance Bookings',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.charcoal,
                                ),
                              ),
                              6.hS,
                              Text(
                                'All advance bookings are up to date or none found.',
                                style: TextStyle(
                                  fontSize: 12.5.sp,
                                  color: AppColor.slateGrey,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  // 4. Data List
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = items[index];
                          final isItemApproving =
                              approveState is ApprovePendingAdvanceLoadingState &&
                                  approveState.bookingId == item.id;

                          return PendingAdvanceBookingCardWidget(
                            item: item,
                            isApproving: isItemApproving,
                            onTap: () {
                              context.pushNamed(
                                AppRoute.pendingAdvanceBookingDetails.name,
                                extra: item.id,
                              );
                            },
                            onApprove: () {
                              context.read<ApprovePendingAdvanceBloc>().add(
                                    ApprovePendingAdvanceSubmitEvent(item.id),
                                  );
                            },
                          );
                        },
                        childCount: items.length,
                      ),
                    ),

              // Bottom pagination spinner
              if (isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ),

              SliverToBoxAdapter(child: 24.hS),
            ],
          ),
        );
          },
        );
      },
    );
  }
}
