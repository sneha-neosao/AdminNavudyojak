part of 'pending_advance_booking_details_bloc.dart';

sealed class PendingAdvanceBookingDetailsState extends Equatable {
  const PendingAdvanceBookingDetailsState();

  @override
  List<Object?> get props => [];
}

class PendingAdvanceBookingDetailsInitialState
    extends PendingAdvanceBookingDetailsState {}

class PendingAdvanceBookingDetailsLoadingState
    extends PendingAdvanceBookingDetailsState {}

class PendingAdvanceBookingDetailsSuccessState
    extends PendingAdvanceBookingDetailsState {
  final PendingAdvanceBookingDetailsResponse data;

  const PendingAdvanceBookingDetailsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class PendingAdvanceBookingDetailsFailureState
    extends PendingAdvanceBookingDetailsState {
  final String message;

  const PendingAdvanceBookingDetailsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
