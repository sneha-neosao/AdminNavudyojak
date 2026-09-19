import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/auth_model/verify_reset_token_response.dart';
import '../../domain/usecase/verify_reset_token_usecase.dart';

part 'verify_reset_token_event.dart';
part 'verify_reset_token_state.dart';

/// Handles state management for **Verify Reset Token** operations adhering to Rule 4.1.
class VerifyResetTokenBloc
    extends Bloc<VerifyResetTokenEvent, VerifyResetTokenState> {
  final VerifyResetTokenUseCase _verifyResetTokenUseCase;

  VerifyResetTokenBloc(this._verifyResetTokenUseCase)
      : super(VerifyResetTokenInitialState()) {
    on<VerifyResetTokenSubmitEvent>(_verifyResetToken);
  }

  Future<void> _verifyResetToken(
    VerifyResetTokenSubmitEvent event,
    Emitter<VerifyResetTokenState> emit,
  ) async {
    emit(VerifyResetTokenLoadingState());

    final result = await _verifyResetTokenUseCase.call(
      VerifyResetTokenParams(token: event.token),
    );

    result.fold(
      (failure) => emit(VerifyResetTokenFailureState(failure.message)),
      (data) => emit(VerifyResetTokenSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE VerifyResetTokenBloc =====");
    return super.close();
  }
}
