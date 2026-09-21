part of 'approve_pending_advance_bloc.dart';

sealed class ApprovePendingAdvanceEvent extends Equatable {
  const ApprovePendingAdvanceEvent();

  @override
  List<Object?> get props => [];
}

class ApprovePendingAdvanceSubmitEvent extends ApprovePendingAdvanceEvent {
  final String bookingId;

  const ApprovePendingAdvanceSubmitEvent(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
