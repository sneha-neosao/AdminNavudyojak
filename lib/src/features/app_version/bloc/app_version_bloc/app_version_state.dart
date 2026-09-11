part of 'app_version_bloc.dart';

sealed class AppVersionState extends Equatable {
  const AppVersionState();

  @override
  List<Object?> get props => [];
}

class AppVersionInitialState extends AppVersionState {}

class AppVersionLoadingState extends AppVersionState {}

class AppVersionSuccessState extends AppVersionState {
  final AppVersionResponse data;

  const AppVersionSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AppVersionFailureState extends AppVersionState {
  final String message;

  const AppVersionFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
