import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/logger.dart';
import '../../../../remote/models/auth_model/change_password_response.dart';
import '../../domain/usecase/change_password_usecase.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

/// Handles state management for **Change Password** adhering to Rule 4.1.
class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordBloc(this._changePasswordUseCase)
    : super(ChangePasswordInitialState()) {
    on<SubmitChangePasswordEvent>(_submitChangePassword);
    on<ResetChangePasswordEvent>(_reset);
  }

  Future<void> _submitChangePassword(
    SubmitChangePasswordEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordLoadingState());

    final result = await _changePasswordUseCase.call(
      ChangePasswordParams(
        userId: event.userId,
        password: event.password,
        passwordConfirm: event.passwordConfirm,
      ),
    );

    result.fold(
      (failure) => emit(ChangePasswordFailureState(failure.message)),
      (data) => emit(ChangePasswordSuccessState(data)),
    );
  }

  Future<void> _reset(
    ResetChangePasswordEvent event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordInitialState());
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ChangePasswordBloc =====");
    return super.close();
  }
}
