part of 'mark_all_notifications_read_bloc.dart';

sealed class MarkAllNotificationsReadState extends Equatable {
  const MarkAllNotificationsReadState();

  @override
  List<Object?> get props => [];
}

class MarkAllNotificationsReadInitialState
    extends MarkAllNotificationsReadState {}

class MarkAllNotificationsReadLoadingState
    extends MarkAllNotificationsReadState {}

class MarkAllNotificationsReadSuccessState
    extends MarkAllNotificationsReadState {
  final MarkAllNotificationsReadResponse data;

  const MarkAllNotificationsReadSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class MarkAllNotificationsReadFailureState
    extends MarkAllNotificationsReadState {
  final String message;

  const MarkAllNotificationsReadFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
