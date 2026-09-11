import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/profile_model/profile_details_response.dart';
import '../../domain/usecase/profile_details_usecase.dart';

part 'profile_details_event.dart';
part 'profile_details_state.dart';

class ProfileDetailsBloc extends Bloc<ProfileDetailsEvent, ProfileDetailsState> {
  final ProfileDetailsUseCase _profileDetailsUseCase;

  ProfileDetailsBloc(
    this._profileDetailsUseCase,
  ) : super(ProfileDetailsInitialState()) {
    on<GetProfileDetailsEvent>(_onGetProfileDetails);
    on<RefreshProfileDetailsEvent>(_onRefreshProfileDetails);
  }

  Future<void> _onGetProfileDetails(
    GetProfileDetailsEvent event,
    Emitter<ProfileDetailsState> emit,
  ) async {
    emit(ProfileDetailsLoadingState());

    final result = await _profileDetailsUseCase.call(NoParams());

    result.fold(
      (failure) => emit(ProfileDetailsFailureState(failure.message)),
      (data) => emit(ProfileDetailsSuccessState(data)),
    );
  }

  Future<void> _onRefreshProfileDetails(
    RefreshProfileDetailsEvent event,
    Emitter<ProfileDetailsState> emit,
  ) async {
    final result = await _profileDetailsUseCase.call(NoParams());

    result.fold(
      (failure) => emit(ProfileDetailsFailureState(failure.message)),
      (data) => emit(ProfileDetailsSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ProfileDetailsBloc =====");
    return super.close();
  }
}
