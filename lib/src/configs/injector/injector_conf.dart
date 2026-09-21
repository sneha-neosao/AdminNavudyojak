import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:admin_navudyojak/src/configs/injector/injector.dart';

final getIt = GetIt.I;

void configureDepedencies() {
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        validateStatus: (status) => status != null && status < 400,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(ApiInterceptor(dio));
    return dio;
  });

  /// App Essentials
  getIt.registerLazySingleton(() => ThemeBloc());

  getIt.registerLazySingleton(() => TranslateBloc());

  getIt.registerLazySingleton(() => AppRouteConf());

  getIt.registerLazySingleton(() => DeepLinkService());

  /// API Helper & Network
  getIt.registerLazySingleton(() => NetworkInfo());

  getIt.registerLazySingleton(() => ApiHelper(getIt<Dio>()));

  /// Remote DataSource & Repository (located at remote folder)
  getIt.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(getIt<ApiHelper>()),
  );

  getIt.registerLazySingleton<Repository>(
    () => AuthRepositoryImpl(getIt<RemoteDataSource>(), getIt<NetworkInfo>()),
  );

  /// UseCases
  getIt.registerLazySingleton<AuthLoginUseCase>(
    () => AuthLoginUseCase(getIt<Repository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<Repository>()),
  );

  getIt.registerLazySingleton<CustomersUseCase>(
    () => CustomersUseCase(getIt<Repository>()),
  );

  getIt.registerLazySingleton<CustomerDetailsUseCase>(
    () => CustomerDetailsUseCase(getIt<Repository>()),
  );

  getIt.registerLazySingleton<AppVersionUseCase>(
    () => AppVersionUseCase(getIt<Repository>()),
  );

  getIt.registerLazySingleton<ProfileDetailsUseCase>(
    () => ProfileDetailsUseCase(getIt<Repository>()),
  );

  getIt.registerLazySingleton<NotificationsUseCase>(
    () => NotificationsUseCase(getIt<Repository>()),
  );

  getIt.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(getIt<Repository>()),
  );

  getIt.registerLazySingleton<VerifyResetTokenUseCase>(
    () => VerifyResetTokenUseCase(getIt<Repository>()),
  );

  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(getIt<Repository>()),
  );

  /// Auth & Login BLoCs registered per Rule 4
  getIt.registerFactory<AuthLoginBloc>(
    () => AuthLoginBloc(getIt<AuthLoginUseCase>(), getIt<LogoutUseCase>()),
  );

  getIt.registerFactory<AuthLoginFormBloc>(() => AuthLoginFormBloc());

  getIt.registerFactory<ForgotPasswordFormBloc>(() => ForgotPasswordFormBloc());

  getIt.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(getIt<ForgotPasswordUseCase>()),
  );

  getIt.registerFactory<VerifyResetTokenBloc>(
    () => VerifyResetTokenBloc(getIt<VerifyResetTokenUseCase>()),
  );

  getIt.registerFactory<ResetPasswordFormBloc>(() => ResetPasswordFormBloc());

  getIt.registerFactory<ResetPasswordBloc>(
    () => ResetPasswordBloc(getIt<ResetPasswordUseCase>()),
  );

  /// Customers BLoC registered per Rule 4
  getIt.registerFactory<CustomersBloc>(
    () => CustomersBloc(getIt<CustomersUseCase>()),
  );

  /// Customer Details BLoC registered per Rule 4
  getIt.registerFactory<CustomerDetailsBloc>(
    () => CustomerDetailsBloc(getIt<CustomerDetailsUseCase>()),
  );

  /// App Version BLoC registered per Rule 4
  getIt.registerFactory<AppVersionBloc>(
    () => AppVersionBloc(getIt<AppVersionUseCase>()),
  );

  /// Profile Details BLoC registered per Rule 4
  getIt.registerFactory<ProfileDetailsBloc>(
    () => ProfileDetailsBloc(getIt<ProfileDetailsUseCase>()),
  );

  /// Notifications BLoC registered per Rule 4
  getIt.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(getIt<NotificationsUseCase>()),
  );

  /// Notifications Count BLoC registered per Rule 4
  getIt.registerLazySingleton<NotificationsCountUseCase>(
    () => NotificationsCountUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<NotificationsCountBloc>(
    () => NotificationsCountBloc(getIt<NotificationsCountUseCase>()),
  );

  /// Mark All Notifications Read UseCase and BLoCs registered per Rule 4
  getIt.registerLazySingleton<MarkAllNotificationsReadUseCase>(
    () => MarkAllNotificationsReadUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<MarkAllNotificationsReadBloc>(
    () =>
        MarkAllNotificationsReadBloc(getIt<MarkAllNotificationsReadUseCase>()),
  );

  /// Mark Single Notification Read UseCase and BLoC registered per Rule 4
  getIt.registerLazySingleton<MarkNotificationReadUseCase>(
    () => MarkNotificationReadUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<MarkNotificationReadBloc>(
    () => MarkNotificationReadBloc(getIt<MarkNotificationReadUseCase>()),
  );

  /// Business Performance Analytics registered per Rule 4
  getIt.registerLazySingleton<BusinessPerformanceUseCase>(
    () => BusinessPerformanceUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<BusinessPerformanceBloc>(
    () => BusinessPerformanceBloc(getIt<BusinessPerformanceUseCase>()),
  );

  /// Update FCM Token registered per Rule 4
  getIt.registerLazySingleton<UpdateFcmTokenUseCase>(
    () => UpdateFcmTokenUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<UpdateFcmTokenBloc>(
    () => UpdateFcmTokenBloc(getIt<UpdateFcmTokenUseCase>()),
  );

  /// Admin Dashboard registered per Rule 4
  getIt.registerLazySingleton<AdminDashboardUseCase>(
    () => AdminDashboardUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<AdminDashboardBloc>(
    () => AdminDashboardBloc(getIt<AdminDashboardUseCase>()),
  );

  /// Change Password registered per Rule 4
  getIt.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<ChangePasswordFormBloc>(() => ChangePasswordFormBloc());

  getIt.registerFactory<ChangePasswordBloc>(
    () => ChangePasswordBloc(getIt<ChangePasswordUseCase>()),
  );

  /// Refunds / Return Requests registered per Rule 4
  getIt.registerLazySingleton<RefundsUseCase>(
    () => RefundsUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<RefundsBloc>(
    () => RefundsBloc(getIt<RefundsUseCase>()),
  );

  /// Pending Advance Bookings registered per Rule 4
  getIt.registerLazySingleton<PendingAdvanceBookingsUseCase>(
    () => PendingAdvanceBookingsUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<PendingAdvanceBookingsBloc>(
    () => PendingAdvanceBookingsBloc(getIt<PendingAdvanceBookingsUseCase>()),
  );

  /// Pending Advance Booking Details registered per Rule 4
  getIt.registerLazySingleton<PendingAdvanceBookingDetailsUseCase>(
    () => PendingAdvanceBookingDetailsUseCase(getIt<Repository>()),
  );

  getIt.registerFactory<PendingAdvanceBookingDetailsBloc>(
    () => PendingAdvanceBookingDetailsBloc(
      getIt<PendingAdvanceBookingDetailsUseCase>(),
    ),
  );
}
