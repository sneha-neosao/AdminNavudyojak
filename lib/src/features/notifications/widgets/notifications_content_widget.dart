import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';
import '../bloc/notifications_bloc/notifications_bloc.dart';
import 'notification_item.dart';
import 'notification_list_card_widget.dart';
import 'notifications_filter_chips_widget.dart';
import 'notifications_header_widget.dart';

class NotificationsContentWidget extends StatefulWidget {
  const NotificationsContentWidget({super.key});

  @override
  State<NotificationsContentWidget> createState() =>
      _NotificationsContentWidgetState();
}

class _NotificationsContentWidgetState
    extends State<NotificationsContentWidget> {
  final ScrollController _scrollController = ScrollController();
  final Set<String> _locallyReadIds = {};
  String _selectedFilter = 'All';

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
        context.read<NotificationsBloc>().add(LoadMoreNotificationsEvent());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  List<NotificationItem> _getFilteredList(List<NotificationItem> items) {
    switch (_selectedFilter) {
      case 'Unread':
        return items.where((n) => !n.isRead).toList();
      case 'Orders':
        return items
            .where((n) => n.type == NotificationType.order)
            .toList();
      case 'Requests':
        return items
            .where((n) => n.type == NotificationType.alert)
            .toList();
      case 'System':
        return items
            .where((n) => n.type == NotificationType.system)
            .toList();
      case 'All':
      default:
        return items;
    }
  }

  void _markAllAsRead(List<NotificationItem> allItems) {
    setState(() {
      _locallyReadIds.addAll(allItems.map((n) => n.id));
    });
    AppSnackBarWidget.show(
      context,
      message: 'All notifications marked as read',
      type: ToastType.success,
    );
  }

  void _onNotificationTap(NotificationItem item) {
    if (!item.isRead) {
      setState(() {
        _locallyReadIds.add(item.id);
      });
    }
    AppSnackBarWidget.show(
      context,
      message: item.title,
      type: ToastType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<NotificationsBloc, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsFailureState) {
          AppSnackBarWidget.show(
            context,
            message: state.message,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is NotificationsLoadingState;
        final isFailure = state is NotificationsFailureState;

        // Transform API models into UI NotificationItems with local read status overlay
        List<NotificationItem> allItems = [];
        bool isLoadingMore = false;

        if (state is NotificationsSuccessState) {
          isLoadingMore = state.isLoadingMore;
          allItems = state.allResults.map((model) {
            final base = model.toNotificationItem();
            if (_locallyReadIds.contains(base.id)) {
              return NotificationItem(
                id: base.id,
                title: base.title,
                message: base.message,
                time: base.time,
                type: base.type,
                isRead: true,
                icon: base.icon,
              );
            }
            return base;
          }).toList();
        }

        final unreadCount = allItems.where((n) => !n.isRead).length;
        final displayedList = _getFilteredList(allItems);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.hS,
            NotificationsHeaderWidget(
              unreadCount: isLoading ? 0 : unreadCount,
              onMarkAllRead: allItems.isEmpty
                  ? null
                  : () => _markAllAsRead(allItems),
            ),
            12.hS,
            NotificationsFilterChipsWidget(
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
            ),
            12.hS,
            Expanded(
              child: RefreshIndicator(
                color: AppColor.cockpitOrange,
                backgroundColor: AppColor.pureWhite,
                onRefresh: () async {
                  context
                      .read<NotificationsBloc>()
                      .add(RefreshNotificationsEvent());
                },
                child: Builder(
                  builder: (context) {
                    // 1. Loading Skeleton with 10 cards
                    if (isLoading) {
                      return _buildSkeletonList();
                    }

                    // 2. Failure Error State
                    if (isFailure && allItems.isEmpty) {
                      return _buildErrorState(context, state.message);
                    }

                    // 3. Empty State
                    if (displayedList.isEmpty) {
                      return _buildEmptyState(theme);
                    }

                    // 4. Notifications List with pagination indicator
                    return ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.only(bottom: 24.h),
                      itemCount: displayedList.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == displayedList.length) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const CircularProgressIndicator(
                                color: AppColor.cockpitOrange,
                                strokeWidth: 2.5,
                              ),
                            ),
                          );
                        }

                        final item = displayedList[index];
                        return NotificationListCardWidget(
                          item: item,
                          onTap: () => _onNotificationTap(item),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds a 10-card skeleton structure using Skeletonizer matching NotificationListCardWidget
  Widget _buildSkeletonList() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        itemCount: 10,
        itemBuilder: (context, index) {
          return const NotificationListCardWidget(
            item: NotificationItem(
              id: 'skeleton',
              title: 'Notification title placeholder',
              message:
                  'Rajesh Patil submitted a return request for machine #BK-3-2026-017.',
              time: '10m ago',
              type: NotificationType.order,
              isRead: false,
              icon: Icons.notifications,
            ),
          );
        },
      ),
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
                'Failed to load notifications',
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
                  context.read<NotificationsBloc>().add(
                        const GetNotificationsEvent(page: 1, limit: 10),
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

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72.r,
                height: 72.r,
                decoration: const BoxDecoration(
                  color: AppColor.avatarBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_off_outlined,
                  size: 36.sp,
                  color: AppColor.cockpitOrange,
                ),
              ),
              16.hS,
              Text(
                'No notifications',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black,
                ),
                softWrap: true,
              ),
              6.hS,
              Text(
                'You have no $_selectedFilter notifications at this moment.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  color: AppColor.textSecondary,
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
