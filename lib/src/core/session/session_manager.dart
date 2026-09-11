import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../remote/models/auth_model/Login_response.dart';
import '../errors/failures.dart';
import '../utils/failure_converter.dart';

/// session for managing the data locally
class SessionManager {
  static Future<bool> checkIsKeyPresent(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", isLoggedIn);
  }

  static Future<bool?> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn");
  }

  static Future<void> saveSessionId(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token ?? "");
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> saveAccessToken(String? token) async {
    await saveSessionId(token);
  }

  static Future<String?> getAccessToken() async {
    return getAuthToken();
  }

  static Future<void> saveRefreshToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("refreshToken", token ?? "");
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("refreshToken");
  }

  static Future<void> saveUserSession(LoginResponse value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userSession", value.toRawJson());
  }

  static Future<LoginResponse?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString("userSession");
    if (raw == null) return null;
    return LoginResponse.fromRawJson(raw);
  }

  static Future<void> saveFirebaseToken(String? firebasetoken) async {
    if (firebasetoken == null || firebasetoken.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("firebasetoken", firebasetoken);
  }

  static Future<String?> getFirebaseToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("firebasetoken");
  }

  static Future<void> saveCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_username", username);
    await prefs.setString("saved_password", password);
  }

  static Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString("saved_username");
    final password = prefs.getString("saved_password");
    if (username != null && password != null) {
      return {'username': username, 'password': password};
    }
    return null;
  }

  static Future<Either<Failure, void>> clear() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Backup credentials before clearing
    final username = prefs.getString("saved_username");
    final password = prefs.getString("saved_password");
    
    final success = await prefs.clear();
    
    // Restore credentials
    if (username != null && password != null) {
      await prefs.setString("saved_username", username);
      await prefs.setString("saved_password", password);
    }

    if (success) {
      return const Right(null);
    } else {
      return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
    }
  }
}

