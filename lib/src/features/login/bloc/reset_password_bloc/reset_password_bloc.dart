import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/auth_model/reset_password_response.dart';
import '../../domain/usecase/reset_password_usecase.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

/// Handles state management for **Reset Password** operations adhering to Rule 4.1.
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordBloc(this._resetPasswordUseCase)
      : super(ResetPasswordInitialState()) {
    on<SubmitResetPasswordEvent>(_submitResetPassword);
  }

  Future<void> _submitResetPassword(
    SubmitResetPasswordEvent event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoadingState());

    final result = await _resetPasswordUseCase.call(
      ResetPasswordParams(
        token: event.token,
        password: event.password,
        passwordConfirm: event.passwordConfirm,
      ),
    );

    result.fold(
      (failure) => emit(ResetPasswordFailureState(failure.message)),
      (data) => emit(ResetPasswordSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ResetPasswordBloc =====");
    return super.close();
  }
}
