import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/profile_model/update_fcm_token_response.dart';
import '../../domain/usecase/update_fcm_token_usecase.dart';

part 'update_fcm_token_event.dart';
part 'update_fcm_token_state.dart';

class UpdateFcmTokenBloc
    extends Bloc<UpdateFcmTokenEvent, UpdateFcmTokenState> {
  final UpdateFcmTokenUseCase _updateFcmTokenUseCase;

  UpdateFcmTokenBloc(
    this._updateFcmTokenUseCase,
  ) : super(UpdateFcmTokenInitialState()) {
    on<SubmitUpdateFcmTokenEvent>(_onSubmitUpdateFcmToken);
  }

  Future<void> _onSubmitUpdateFcmToken(
    SubmitUpdateFcmTokenEvent event,
    Emitter<UpdateFcmTokenState> emit,
  ) async {
    emit(UpdateFcmTokenLoadingState());

    final result = await _updateFcmTokenUseCase.call(
      UpdateFcmTokenParams(fcmToken: event.fcmToken),
    );

    result.fold(
      (failure) => emit(UpdateFcmTokenFailureState(failure.message)),
      (data) => emit(UpdateFcmTokenSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE UpdateFcmTokenBloc =====");
    return super.close();
  }
}
