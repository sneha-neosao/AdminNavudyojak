enum AppRoute {
  splash(path: "/splash"),
  login(path: "/login"),
  mainScreen(path: "/main"),
  home(path: "/home"),
  analytics(path: "/analytics"),
  customers(path: "/customers"),
  customerOnboardingDetails(path: "/customer-onboarding-details"),
  requests(path: "/requests"),
  settings(path: "/settings"),
  notifications(path: "/notifications"),
  maintenance(path: "/maintenance"),
  resetPassword(path: "/reset-password"),
  pendingAdvanceBookings(path: "/pending-advance-bookings"),
  pendingAdvanceBookingDetails(path: "/pending-advance-booking-details");

  final String path;

  const AppRoute({required this.path});
}
