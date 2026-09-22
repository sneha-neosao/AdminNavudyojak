import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/theme/app_color.dart';
import '../../../bookings/bloc/approve_pending_advance_bloc/approve_pending_advance_bloc.dart';
import '../../../bookings/bloc/pending_advance_bookings_bloc/pending_advance_bookings_bloc.dart';
import '../../bloc/refunds_bloc/refunds_bloc.dart';
import '../../widgets/request_content_widget.dart';

class RequestsScreen extends StatefulWidget {
  final int initialTabIndex;

  const RequestsScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late final RefundsBloc _refundsBloc;
  late final PendingAdvanceBookingsBloc _pendingAdvanceBookingsBloc;
  late final ApprovePendingAdvanceBloc _approvePendingAdvanceBloc;

  @override
  void initState() {
    super.initState();
    _refundsBloc = getIt<RefundsBloc>()..add(const GetRefundsEvent());
    _pendingAdvanceBookingsBloc = getIt<PendingAdvanceBookingsBloc>()
      ..add(const GetPendingAdvanceBookingsEvent());
    _approvePendingAdvanceBloc = getIt<ApprovePendingAdvanceBloc>();
  }

  @override
  void dispose() {
    _refundsBloc.close();
    _pendingAdvanceBookingsBloc.close();
    _approvePendingAdvanceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RefundsBloc>.value(value: _refundsBloc),
        BlocProvider<PendingAdvanceBookingsBloc>.value(
          value: _pendingAdvanceBookingsBloc,
        ),
        BlocProvider<ApprovePendingAdvanceBloc>.value(
          value: _approvePendingAdvanceBloc,
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.pureWhite,
        body: SafeArea(
          bottom: false,
          child: RequestContentWidget(
            initialTabIndex: widget.initialTabIndex,
          ),
        ),
      ),
    );
  }
}

