part of 'admin_dashboard_bloc.dart';

sealed class AdminDashboardState extends Equatable {
  const AdminDashboardState();

  @override
  List<Object?> get props => [];
}

class AdminDashboardInitialState extends AdminDashboardState {}

class AdminDashboardLoadingState extends AdminDashboardState {}

class AdminDashboardSuccessState extends AdminDashboardState {
  final AdminDashboardResponse data;
  final bool isChangingPeriod;
  final String currentPeriod;

  const AdminDashboardSuccessState(
    this.data, {
    this.isChangingPeriod = false,
    this.currentPeriod = 'this_week',
  });

  AdminDashboardSuccessState copyWith({
    AdminDashboardResponse? data,
    bool? isChangingPeriod,
    String? currentPeriod,
  }) {
    return AdminDashboardSuccessState(
      data ?? this.data,
      isChangingPeriod: isChangingPeriod ?? this.isChangingPeriod,
      currentPeriod: currentPeriod ?? this.currentPeriod,
    );
  }

  @override
  List<Object?> get props => [data, isChangingPeriod, currentPeriod];
}

class AdminDashboardFailureState extends AdminDashboardState {
  final String message;

  const AdminDashboardFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
