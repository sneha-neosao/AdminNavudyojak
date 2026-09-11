import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:admin_navudyojak/src/core/errors/exceptions.dart';
import 'package:admin_navudyojak/src/core/errors/failures.dart';
import 'package:admin_navudyojak/src/core/session/session_manager.dart';
import 'package:admin_navudyojak/src/core/usecases/usecase.dart';
import 'package:admin_navudyojak/src/core/utils/failure_converter.dart';
import 'package:admin_navudyojak/src/core/utils/logger.dart';
import 'package:admin_navudyojak/src/remote/models/auth_model/Login_response.dart';
import 'package:admin_navudyojak/src/remote/models/common_response.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';

part 'auth_login_event.dart';
part 'auth_login_state.dart';

/// Handles state management for **Auth Login** and its related operations.
class AuthLoginBloc extends Bloc<AuthEvent, AuthLoginState> {
  final AuthLoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthLoginBloc(
    this._loginUseCase,
    this._logoutUseCase,
  ) : super(AuthLoginInitialState()) {
    on<AuthLoginEvent>(_login);
    on<AuthCheckSignInStatusEvent>(_checkSignInStatus);
    on<AuthLogoutEvent>(_logout);
  }

  /// - **Login:** Handles [AuthLoginEvent] → calls [AuthLoginUseCase]
  Future _login(AuthLoginEvent event, Emitter emit) async {
    emit(AuthLoginLoadingState());

    final result = await _loginUseCase.call(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (l) => emit(AuthLoginFailureState(l.message)),
      (r) => emit(AuthLoginSuccessState(r)),
    );
  }

  /// - **Check Sign-In Status:** Handles [AuthCheckSignInStatusEvent] → checks [SessionManager]
  Future<Either<Failure, LoginResponse>> checkSignInStatus() async {
    try {
      final result = await SessionManager.isLoggedIn();

      if (result == true) {
        final resultData = await SessionManager.getUserSession();
        if (resultData != null) {
          return Right(resultData);
        }
      }
      return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
    } on CacheException {
      return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
    }
  }

  Future _checkSignInStatus(
      AuthCheckSignInStatusEvent event, Emitter emit) async {
    emit(AuthCheckSignInStatusLoadingState());

    final result = await checkSignInStatus();
    result.fold(
      (l) => emit(AuthCheckSignInStatusFailureState(mapFailureToMessage(l))),
      (r) => emit(AuthCheckSignInStatusSuccessState(r)),
    );
  }

  /// - **Logout:** Handles [AuthLogoutEvent] → clears [SessionManager]
  Future _logout(AuthLogoutEvent event, Emitter emit) async {
    emit(AuthLogoutLoadingState());

    final result = await _logoutUseCase.call(NoParams());

    result.fold(
      (l) => emit(AuthLogoutFailureState(l.message)),
      (r) => emit(AuthLogoutSuccessState(r)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE AuthLoginBloc =====");
    return super.close();
  }
}
