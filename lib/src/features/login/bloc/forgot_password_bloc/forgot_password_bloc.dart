import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/auth_model/forgot_password_response.dart';
import '../../domain/usecase/forgot_password_usecase.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

/// Handles state management for **Forgot Password** adhering to Rule 4.1.
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordBloc(this._forgotPasswordUseCase)
      : super(ForgotPasswordInitialState()) {
    on<SendForgotPasswordEvent>(_sendForgotPassword);
  }

  Future<void> _sendForgotPassword(
    SendForgotPasswordEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoadingState());

    final result = await _forgotPasswordUseCase.call(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
      (failure) => emit(ForgotPasswordFailureState(failure.message)),
      (data) => emit(ForgotPasswordSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ForgotPasswordBloc =====");
    return super.close();
  }
}
