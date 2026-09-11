part of 'admin_dashboard_bloc.dart';

sealed class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent();

  @override
  List<Object?> get props => [];
}

class GetAdminDashboardEvent extends AdminDashboardEvent {
  final String period;

  const GetAdminDashboardEvent({this.period = 'this_week'});

  @override
  List<Object?> get props => [period];
}

class ChangePeriodEvent extends AdminDashboardEvent {
  final String period;

  const ChangePeriodEvent(this.period);

  @override
  List<Object?> get props => [period];
}

class RefreshAdminDashboardEvent extends AdminDashboardEvent {
  const RefreshAdminDashboardEvent();
}
