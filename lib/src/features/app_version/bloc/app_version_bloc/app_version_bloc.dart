import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecase/app_version_usecase.dart';
import '../../../../remote/models/app_version_model/app_version_response.dart';

part 'app_version_event.dart';
part 'app_version_state.dart';

class AppVersionBloc extends Bloc<AppVersionEvent, AppVersionState> {
  final AppVersionUseCase _appVersionUseCase;

  AppVersionBloc(this._appVersionUseCase) : super(AppVersionInitialState()) {
    on<CheckAppVersionEvent>(_checkAppVersion);
  }

  Future<void> _checkAppVersion(
    CheckAppVersionEvent event,
    Emitter<AppVersionState> emit,
  ) async {
    emit(AppVersionLoadingState());

    final result = await _appVersionUseCase.call(
      AppVersionParams(appName: event.appName),
    );

    result.fold(
      (failure) => emit(AppVersionFailureState(failure.message)),
      (data) => emit(AppVersionSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE AppVersionBloc =====");
    return super.close();
  }
}
