class ApiUrl {
  const ApiUrl._();

  // static const baseUrl = "https://mnkbackend.neosao.co.in/api"; // LIVE
  static const baseUrl = "http://192.168.1.6:8000/api"; // LOCAL

  // static const baseUrl = "https://9hjbbxk2-8000.inc1.devtunnels.ms/api";

  static const login = "/auth/login";

  static const logout = "/auth/logout";

  static const customers = "/admin-app/customers";

  static String customerDetails(String id) => "/admin-app/customers/$id";

  static const firebaseTokenUpdate = "/profile/update-firebase-token";
  static const updateFcmToken = "/auth/profile/update-fcm-token";

  static const orderList = "/orders/list";

  static const orderDetails = "/orders/detail";

  static const orderAssignment = "/orders/accept-reject";

  static const orderStatusUpdate = "/orders/update-status";

  static const orderCurrentAssignment = "/orders/current-assignment";

  static const orderStartAssignment = "/orders/start";

  static const currentAssignmentOrders = "/orders/current-assignment/orders";

  static const foodCurrentAssignment = "/food-orders/current-assignment";

  static const profile = "/auth/profile";
  static const authProfile = "/auth/profile";
  static const forgotPassword = "/auth/forgot-password";
  static const verifyResetToken = "/auth/verify-reset-token";
  static const resetPassword = "/auth/reset-password";

  static const onlineStatus = "/auth/toggle-online";

  static const dashboard = "/dashboard/";

  static const passwordUpdate = "/profile/update-password";
  static String changePassword(String userId) =>
      "/auth/change-password/$userId";

  static const profileUpdate = "/profile/update";

  static const profileImageUpdate = "/profile/update-image";

  static const appUpdate = "/app-version";

  static const String appVersionCheck = "/common/app-versions/check/";
  static String appVersionCheckUrl({String appName = 'admin_app'}) =>
      "/common/app-versions/check/?app_name=$appName";

  static const notifications = "/notifications";
  static const notificationsCounts = "/notifications/counts";
  static const markAllNotificationsAsRead = "/notifications/mark-all-as-read";
  static String markNotificationAsRead(String id) =>
      "/notifications/$id/mark-as-read";
  static String notificationsUrl({int? page, int? limit, String? status}) {
    final queryParams = <String>[];
    if (page != null) queryParams.add("page=$page");
    if (limit != null) queryParams.add("limit=$limit");
    if (status != null && status.isNotEmpty) queryParams.add("status=$status");
    if (queryParams.isEmpty) return notifications;
    return "$notifications?${queryParams.join('&')}";
  }

  static const businessPerformance =
      "/admin-app/analytics/business-performance";
  static const adminDashboard = "/admin-app/dashboard";
  static String adminDashboardUrl({String? period}) {
    if (period != null && period.isNotEmpty) {
      return "$adminDashboard?period=$period";
    }
    return adminDashboard;
  }

  static const deleteAccount = "/auth/delete";

  static const refunds = "/admin-app/refunds";
  static String refundsUrl({
    int? page,
    int? limit,
    String? status,
    String? search,
    String? dateFrom,
    String? dateTo,
    String? isDashboard,
    String? ordering,
    String? refundType,
  }) {
    final queryParams = <String>[];
    if (page != null) queryParams.add("page=$page");
    if (limit != null) queryParams.add("limit=$limit");
    if (status != null && status.isNotEmpty) queryParams.add("status=$status");
    if (search != null && search.isNotEmpty) queryParams.add("search=$search");
    if (dateFrom != null && dateFrom.isNotEmpty) {
      queryParams.add("date_from=$dateFrom");
    }
    if (dateTo != null && dateTo.isNotEmpty) {
      queryParams.add("date_to=$dateTo");
    }
    if (isDashboard != null && isDashboard.isNotEmpty) {
      queryParams.add("is_dashboard=$isDashboard");
    }
    if (ordering != null && ordering.isNotEmpty) {
      queryParams.add("ordering=$ordering");
    }
    if (refundType != null && refundType.isNotEmpty) {
      queryParams.add("refund_type=$refundType");
    }
    if (queryParams.isEmpty) return refunds;
    return "$refunds?${queryParams.join('&')}";
  }

  static const pendingAdvanceBookings = "/admin-app/bookings/pending-advances";
  static String pendingAdvanceBookingsUrl({
    int? page,
    int? limit,
    String? search,
  }) {
    final queryParams = <String>[];
    if (page != null) queryParams.add("page=$page");
    if (limit != null) queryParams.add("limit=$limit");
    if (search != null && search.isNotEmpty) queryParams.add("search=$search");
    if (queryParams.isEmpty) return pendingAdvanceBookings;
    return "$pendingAdvanceBookings?${queryParams.join('&')}";
  }

  static String pendingAdvanceBookingDetails(String id) =>
      "/admin-app/bookings/pending-advances/$id";
}
