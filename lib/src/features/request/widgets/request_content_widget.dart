import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../bookings/bloc/pending_advance_bookings_bloc/pending_advance_bookings_bloc.dart';
import '../../bookings/presentation/widgets/pending_advance_bookings_content_widget.dart';
import '../bloc/refunds_bloc/refunds_bloc.dart';
import 'requests_header_widget.dart';
import 'requests_list_widget.dart';
import 'requests_tab_bar_widget.dart';

class RequestContentWidget extends StatefulWidget {
  final int initialTabIndex;

  const RequestContentWidget({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<RequestContentWidget> createState() => _RequestContentWidgetState();
}

class _RequestContentWidgetState extends State<RequestContentWidget>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 1),
    );
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final refundsState = context.watch<RefundsBloc>().state;
    final bookingsState = context.watch<PendingAdvanceBookingsBloc>().state;

    int requestsCount = 0;
    if (refundsState is RefundsSuccessState) {
      requestsCount = refundsState.data.data?.pagination?.count ??
          refundsState.allResults.length;
    }

    int bookingsCount = 0;
    if (bookingsState is PendingAdvanceBookingsSuccessState) {
      bookingsCount = bookingsState.data.data?.pagination?.count ??
          bookingsState.allResults.length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.hS,
        RequestsHeaderWidget(selectedTab: _tabController.index),
        12.hS,
        RequestsTabBarWidget(
          tabController: _tabController,
          requestsCount: requestsCount,
          bookingsCount: bookingsCount,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: const [
              RequestsListWidget(),
              PendingAdvanceBookingsContentWidget(showHeader: false),
            ],
          ),
        ),
      ],
    );
  }
}

