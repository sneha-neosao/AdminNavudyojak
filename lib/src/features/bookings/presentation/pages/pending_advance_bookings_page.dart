import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/pending_advance_bookings_bloc/pending_advance_bookings_bloc.dart';
import '../widgets/pending_advance_bookings_content_widget.dart';

class PendingAdvanceBookingsScreen extends StatefulWidget {
  const PendingAdvanceBookingsScreen({super.key});

  @override
  State<PendingAdvanceBookingsScreen> createState() =>
      _PendingAdvanceBookingsScreenState();
}

class _PendingAdvanceBookingsScreenState
    extends State<PendingAdvanceBookingsScreen> {
  late final PendingAdvanceBookingsBloc _pendingAdvanceBookingsBloc;

  @override
  void initState() {
    super.initState();
    _pendingAdvanceBookingsBloc = getIt<PendingAdvanceBookingsBloc>();
    _pendingAdvanceBookingsBloc.add(const GetPendingAdvanceBookingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PendingAdvanceBookingsBloc>.value(
          value: _pendingAdvanceBookingsBloc,
        ),
      ],
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.pureWhite,
        body: SafeArea(
          bottom: false,
          child: PendingAdvanceBookingsContentWidget(),
        ),
      ),
    );
  }
}
