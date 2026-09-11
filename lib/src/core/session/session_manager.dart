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

  static const String _keyRememberEmail = "remember_email";
  static const String _keyRememberPassword = "remember_password";

  /// Persistent Remember-Me Session (persists even if user logs out)
  /// Saves the two string values: [email] and [password].
  static Future<void> saveRememberCredentials({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRememberEmail, email);
    await prefs.setString(_keyRememberPassword, password);
    // Also save legacy keys for full compatibility
    await prefs.setString("saved_username", email);
    await prefs.setString("saved_password", password);
  }

  /// Retrieves the two saved string values: [email] and [password] from the persistent session.
  /// Returns a map with 'email' and 'password' or null if not saved.
  static Future<Map<String, String>?> getRememberCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyRememberEmail) ?? prefs.getString("saved_username");
    final password = prefs.getString(_keyRememberPassword) ?? prefs.getString("saved_password");
    if (email != null && password != null && email.isNotEmpty && password.isNotEmpty) {
      return {
        'email': email,
        'password': password,
        'username': email,
      };
    }
    return null;
  }

  /// Clears the persistent remember-me credentials session.
  static Future<void> clearRememberCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRememberEmail);
    await prefs.remove(_keyRememberPassword);
    await prefs.remove("saved_username");
    await prefs.remove("saved_password");
  }

  /// Checks if remember-me credentials are saved.
  static Future<bool> hasRememberCredentials() async {
    final creds = await getRememberCredentials();
    return creds != null;
  }

  /// Backward-compatible aliases
  static Future<void> saveCredentials(String username, String password) async {
    await saveRememberCredentials(email: username, password: password);
  }

  static Future<Map<String, String>?> getSavedCredentials() async {
    return getRememberCredentials();
  }

  /// Clears the login session (tokens, user profile, etc.)
  /// NOTE: This does NOT clear the persistent Remember-Me session!
  static Future<Either<Failure, void>> clear() async {
    final prefs = await SharedPreferences.getInstance();

    // Backup remember-me credentials before clearing
    final rememberEmail = prefs.getString(_keyRememberEmail) ?? prefs.getString("saved_username");
    final rememberPassword = prefs.getString(_keyRememberPassword) ?? prefs.getString("saved_password");

    final success = await prefs.clear();

    // Restore remember-me credentials so they persist across logout
    if (rememberEmail != null && rememberPassword != null) {
      await prefs.setString(_keyRememberEmail, rememberEmail);
      await prefs.setString(_keyRememberPassword, rememberPassword);
      await prefs.setString("saved_username", rememberEmail);
      await prefs.setString("saved_password", rememberPassword);
    }

    if (success) {
      return const Right(null);
    } else {
      return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
    }
  }
}

