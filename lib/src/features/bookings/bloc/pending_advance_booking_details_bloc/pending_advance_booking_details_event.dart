part of 'pending_advance_booking_details_bloc.dart';

sealed class PendingAdvanceBookingDetailsEvent extends Equatable {
  const PendingAdvanceBookingDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetPendingAdvanceBookingDetailsEvent
    extends PendingAdvanceBookingDetailsEvent {
  final String id;

  const GetPendingAdvanceBookingDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshPendingAdvanceBookingDetailsEvent
    extends PendingAdvanceBookingDetailsEvent {
  final String id;

  const RefreshPendingAdvanceBookingDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}
