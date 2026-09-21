import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/pending_advance_booking_details_bloc/pending_advance_booking_details_bloc.dart';
import '../widgets/pending_advance_booking_details_content_widget.dart';

class PendingAdvanceBookingDetailsScreen extends StatefulWidget {
  final String? bookingId;

  const PendingAdvanceBookingDetailsScreen({
    super.key,
    this.bookingId,
  });

  @override
  State<PendingAdvanceBookingDetailsScreen> createState() =>
      _PendingAdvanceBookingDetailsScreenState();
}

class _PendingAdvanceBookingDetailsScreenState
    extends State<PendingAdvanceBookingDetailsScreen> {
  late final PendingAdvanceBookingDetailsBloc _detailsBloc;

  @override
  void initState() {
    super.initState();
    _detailsBloc = getIt<PendingAdvanceBookingDetailsBloc>();
    if (widget.bookingId != null && widget.bookingId!.isNotEmpty) {
      _detailsBloc.add(GetPendingAdvanceBookingDetailsEvent(widget.bookingId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PendingAdvanceBookingDetailsBloc>.value(
          value: _detailsBloc,
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.pureWhite,
        body: SafeArea(
          bottom: false,
          child: PendingAdvanceBookingDetailsContentWidget(
            bookingId: widget.bookingId ?? '',
          ),
        ),
      ),
    );
  }
}
