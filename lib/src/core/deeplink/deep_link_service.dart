import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

/// Service to handle deep linking across the application.
///
/// - Subscribes to incoming URIs via [AppLinks.uriLinkStream].
/// - Provides [checkInitialUri] for cold-start deep links.
/// - Matches implementation pattern from EngageReward-flutter.
class DeepLinkService {
  StreamSubscription<Uri>? _sub;

  /// Initializes a listener for incoming deep links while the app is running or in the background.
  void initListener(void Function(Uri) onUriReceived) {
    final appLinks = AppLinks();

    _sub = appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint("🔗 Received URI: $uri");
        onUriReceived(uri);
      },
      onError: (err) {
        debugPrint("❌ Deep link stream error: $err");
      },
    );
  }

  /// Checks for any initial deep link that opened the app on cold start.
  Future<void> checkInitialUri(void Function(Uri) onUriReceived) async {
    try {
      final appLinks = AppLinks();
      final uri = await appLinks.getInitialLink();
      if (uri != null) {
        debugPrint("🔗 Initial URI: $uri");
        onUriReceived(uri);
      }
    } catch (e) {
      debugPrint("❌ Failed to get initial URI: $e");
    }
  }

  /// Cancels active stream subscriptions.
  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
