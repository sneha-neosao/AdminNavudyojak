part of 'approve_pending_advance_bloc.dart';

sealed class ApprovePendingAdvanceState extends Equatable {
  const ApprovePendingAdvanceState();

  @override
  List<Object?> get props => [];
}

class ApprovePendingAdvanceInitialState extends ApprovePendingAdvanceState {}

class ApprovePendingAdvanceLoadingState extends ApprovePendingAdvanceState {
  final String bookingId;

  const ApprovePendingAdvanceLoadingState(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class ApprovePendingAdvanceSuccessState extends ApprovePendingAdvanceState {
  final ApprovePendingAdvanceResponse data;
  final String bookingId;

  const ApprovePendingAdvanceSuccessState(this.data, this.bookingId);

  @override
  List<Object?> get props => [data, bookingId];
}

class ApprovePendingAdvanceFailureState extends ApprovePendingAdvanceState {
  final String message;
  final String bookingId;

  const ApprovePendingAdvanceFailureState(this.message, this.bookingId);

  @override
  List<Object?> get props => [message, bookingId];
}
