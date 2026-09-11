class ApiUrl {
  const ApiUrl._();

  // static const baseUrl = "https://myvegizapis.neosao.co.in/api/v1/delivery_boy"; // LIVE
  static const baseUrl = "http://192.168.1.13:8000/api"; // LOCAL / TEST

  // static const socketUrl = "http://172.20.10.2:8001"; // Socket
  static const socketUrl = "http://192.168.1.13:8000"; // Socket

  static const login = "/auth/login";

  static const logout = "/auth/logout";

  static const customers = "/admin-app/customers";

  static const firebaseTokenUpdate = "/profile/update-firebase-token";

  static const orderList = "/orders/list";

  static const orderDetails = "/orders/detail";

  static const orderAssignment = "/orders/accept-reject";

  static const orderStatusUpdate = "/orders/update-status";

  static const orderCurrentAssignment = "/orders/current-assignment";

  static const orderStartAssignment = "/orders/start";

  static const currentAssignmentOrders = "/orders/current-assignment/orders";

  static const foodCurrentAssignment = "/food-orders/current-assignment";

  static const profile = "/profile/details";

  static const onlineStatus = "/auth/toggle-online";

  static const dashboard = "/dashboard/";

  static const passwordUpdate = "/profile/update-password";

  static const profileUpdate = "/profile/update";

  static const profileImageUpdate = "/profile/update-image";

  static const appUpdate = "/app-version";

  static const deleteAccount = "/auth/delete";
}

