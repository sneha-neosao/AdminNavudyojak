import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';

part 'reset_password_form_event.dart';
part 'reset_password_form_state.dart';

/// Handles validation logic for **Reset Password Form Inputs** adhering to Rule 4.2.
class ResetPasswordFormBloc
    extends Bloc<ResetPasswordFormEvent, ResetPasswordFormState> {
  ResetPasswordFormBloc() : super(const ResetPasswordFormInitialState()) {
    on<ResetPasswordPasswordChangedEvent>(_passwordChanged);
    on<ResetPasswordConfirmPasswordChangedEvent>(_confirmPasswordChanged);
  }

  Future<void> _passwordChanged(
    ResetPasswordPasswordChangedEvent event,
    Emitter<ResetPasswordFormState> emit,
  ) async {
    emit(
      ResetPasswordFormDataState(
        password: event.password,
        passwordConfirm: state.passwordConfirm,
        isValid: _validate(event.password, state.passwordConfirm),
      ),
    );
  }

  Future<void> _confirmPasswordChanged(
    ResetPasswordConfirmPasswordChangedEvent event,
    Emitter<ResetPasswordFormState> emit,
  ) async {
    emit(
      ResetPasswordFormDataState(
        password: state.password,
        passwordConfirm: event.passwordConfirm,
        isValid: _validate(state.password, event.passwordConfirm),
      ),
    );
  }

  bool _validate(String password, String confirm) {
    if (password.isNotEmpty &&
        confirm.isNotEmpty &&
        password == confirm &&
        password.length >= 6) {
      return true;
    }
    return false;
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ResetPasswordFormBloc =====");
    return super.close();
  }
}
