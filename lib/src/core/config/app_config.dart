import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralizes access to environment variables loaded from the `.env` file.
/// Always access values through this class rather than reading `dotenv` directly.
class AppConfig {
  const AppConfig._();

  /// The base URL for all API requests (without trailing slash).
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://mnkbackend.neosao.co.in/api';

  /// Current app environment (development | staging | production).
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';

  static bool get isDevelopment => appEnv == 'development';
  static bool get isProduction => appEnv == 'production';
}
