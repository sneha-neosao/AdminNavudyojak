import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/logger.dart';

part 'change_password_form_event.dart';
part 'change_password_form_state.dart';

/// Handles validation logic for **Change Password Form Inputs** adhering to Rule 4.2.
class ChangePasswordFormBloc
    extends Bloc<ChangePasswordFormEvent, ChangePasswordFormState> {
  ChangePasswordFormBloc() : super(const ChangePasswordFormInitialState()) {
    on<ChangePasswordPasswordChangedEvent>(_passwordChanged);
    on<ChangePasswordConfirmChangedEvent>(_confirmPasswordChanged);
    on<ChangePasswordFormResetEvent>(_reset);
  }

  Future<void> _passwordChanged(
    ChangePasswordPasswordChangedEvent event,
    Emitter<ChangePasswordFormState> emit,
  ) async {
    emit(
      ChangePasswordFormDataState(
        inputPassword: event.password,
        inputPasswordConfirm: state.passwordConfirm,
        inputIsValid: inputValidator(event.password, state.passwordConfirm),
      ),
    );
  }

  Future<void> _confirmPasswordChanged(
    ChangePasswordConfirmChangedEvent event,
    Emitter<ChangePasswordFormState> emit,
  ) async {
    emit(
      ChangePasswordFormDataState(
        inputPassword: state.password,
        inputPasswordConfirm: event.passwordConfirm,
        inputIsValid: inputValidator(state.password, event.passwordConfirm),
      ),
    );
  }

  Future<void> _reset(
    ChangePasswordFormResetEvent event,
    Emitter<ChangePasswordFormState> emit,
  ) async {
    emit(const ChangePasswordFormInitialState());
  }

  bool inputValidator(String password, String confirmPassword) {
    if (password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword) {
      return true;
    }
    return false;
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ChangePasswordFormBloc =====");
    return super.close();
  }
}
