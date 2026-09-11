import 'package:admin_navudyojak/src/features/notifications/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';
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
  String _selectedFilter = 'All';

  late List<NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      const NotificationItem(
        id: '1',
        title: 'Machine return requested',
        message:
            'Rajesh Patil submitted a return request for machine #BK-3-2026-017 (₹45,000).',
        time: '5m ago',
        type: NotificationType.alert,
        isRead: false,
        icon: Icons.warning_amber_rounded,
      ),
      const NotificationItem(
        id: '2',
        title: 'New customer onboarded',
        message:
            'Sunita Sharma completed business verification and KYC from Pune.',
        time: '25m ago',
        type: NotificationType.customer,
        isRead: false,
        icon: Icons.person_add_alt_1_outlined,
      ),
      const NotificationItem(
        id: '3',
        title: 'Settlement ready for review',
        message:
            'Return settlement for Aniket Shinde of ₹62,000 is awaiting owner confirmation.',
        time: '1h ago',
        type: NotificationType.order,
        isRead: false,
        icon: Icons.assignment_outlined,
      ),
      const NotificationItem(
        id: '4',
        title: 'Bulk order dispatch',
        message:
            'Vijay Kumar placed an order for 500 KG Copper Wire (LG-3-2026-010).',
        time: '3h ago',
        type: NotificationType.order,
        isRead: true,
        icon: Icons.local_shipping_outlined,
      ),
      const NotificationItem(
        id: '5',
        title: 'System update completed',
        message:
            'Security audit and database ledger sync finished successfully at 04:00 AM.',
        time: '8h ago',
        type: NotificationType.system,
        isRead: true,
        icon: Icons.check_circle_outline_rounded,
      ),
      const NotificationItem(
        id: '6',
        title: 'Delivery milestone achieved',
        message:
            'Consignment #BK-3-2026-016 delivered to Rajarampuri, Kolhapur.',
        time: 'Yesterday',
        type: NotificationType.order,
        isRead: true,
        icon: Icons.inventory_2_outlined,
      ),
      const NotificationItem(
        id: '7',
        title: 'Alert resolved',
        message:
            'Owner margin warning threshold for Vikram Patil marked as resolved.',
        time: 'Yesterday',
        type: NotificationType.alert,
        isRead: true,
        icon: Icons.shield_outlined,
      ),
    ];
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationItem> get _filteredNotifications {
    switch (_selectedFilter) {
      case 'Unread':
        return _notifications.where((n) => !n.isRead).toList();
      case 'Orders':
        return _notifications
            .where((n) => n.type == NotificationType.order)
            .toList();
      case 'Requests':
        return _notifications
            .where((n) => n.type == NotificationType.alert)
            .toList();
      case 'System':
        return _notifications
            .where((n) => n.type == NotificationType.system)
            .toList();
      case 'All':
      default:
        return _notifications;
    }
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map(
            (n) => NotificationItem(
              id: n.id,
              title: n.title,
              message: n.message,
              time: n.time,
              type: n.type,
              isRead: true,
              icon: n.icon,
            ),
          )
          .toList();
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
        final index = _notifications.indexWhere((n) => n.id == item.id);
        if (index != -1) {
          final current = _notifications[index];
          _notifications[index] = NotificationItem(
            id: current.id,
            title: current.title,
            message: current.message,
            time: current.time,
            type: current.type,
            isRead: true,
            icon: current.icon,
          );
        }
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
    final displayedList = _filteredNotifications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.hS,
        NotificationsHeaderWidget(
          unreadCount: _unreadCount,
          onMarkAllRead: _markAllAsRead,
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
          child: displayedList.isEmpty
              ? _buildEmptyState(theme)
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: displayedList.length,
                  itemBuilder: (context, index) {
                    final item = displayedList[index];
                    return NotificationListCardWidget(
                      item: item,
                      onTap: () => _onNotificationTap(item),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72.r,
              height: 72.r,
              decoration: BoxDecoration(
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
    );
  }
}
