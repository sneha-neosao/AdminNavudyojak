import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/string_validator_extension.dart';
import '../../../../core/utils/logger.dart';

part 'forgot_password_form_event.dart';
part 'forgot_password_form_state.dart';

/// Handles validation logic for **Forgot Password Form Inputs** adhering to Rule 4.2.
class ForgotPasswordFormBloc
    extends Bloc<ForgotPasswordFormEvent, ForgotPasswordFormState> {
  ForgotPasswordFormBloc() : super(const ForgotPasswordFormInitialState()) {
    on<ForgotPasswordEmailChangedEvent>(_emailChanged);
  }

  /// Listens to changes in email input
  Future<void> _emailChanged(
    ForgotPasswordEmailChangedEvent event,
    Emitter<ForgotPasswordFormState> emit,
  ) async {
    final trimmed = event.email.trim();
    emit(
      ForgotPasswordFormDataState(
        inputEmail: trimmed,
        inputIsValid: inputValidator(trimmed),
      ),
    );
  }

  bool inputValidator(String email) {
    if (email.isNotEmpty && email.isEmailValid) {
      return true;
    }
    return false;
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ForgotPasswordFormBloc =====");
    return super.close();
  }
}
