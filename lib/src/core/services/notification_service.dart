import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:admin_navudyojak/firebase_options.dart';
import 'package:admin_navudyojak/src/core/session/session_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

typedef NotificationService = NoficationService;

class NoficationService {
  // ============================================================
  // CHANNEL IDS
  // ============================================================

  /// 🔕 General channel - all notifications
  static const String generalChannelId = 'general_channel';
  static const String generalChannelName = 'General';

  /// 📥 Download channel - progress notifications
  static const String downloadChannelId = 'download_channel';
  static const String downloadChannelName = 'File Downloads';

  // ============================================================
  // STREAMS
  // ============================================================

  static final StreamController<RemoteMessage>
  _onMessageStreamController =
  StreamController<RemoteMessage>.broadcast();

  static Stream<RemoteMessage> get onMessageStream =>
      _onMessageStreamController.stream;

  static final StreamController<String>
  _onTokenRefreshStreamController =
  StreamController<String>.broadcast();

  static Stream<String> get onTokenRefreshStream =>
      _onTokenRefreshStreamController.stream;

  // ============================================================
  // LOCAL NOTIFICATION PLUGIN
  // ============================================================

  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // ============================================================
  // REQUEST PERMISSION
  // ============================================================

  static Future<void> requestNotificationPermission() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final NotificationSettings settings =
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // ============================================================
  // GET FCM TOKEN
  // ============================================================

  static Future<String?> getToken() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      final FirebaseMessaging messaging =
          FirebaseMessaging.instance;

      final String? token = await messaging.getToken();

      print('FCM Token: $token');

      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  // ============================================================
  // INITIALIZE LOCAL NOTIFICATIONS
  // ============================================================

  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings
    androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) {
        print(
          '🔔 Local notification tapped with payload: ${response.payload}',
        );

        if (response.payload != null &&
            response.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> data =
            Map<String, dynamic>.from(
              jsonDecode(response.payload!),
            );

            _onMessageStreamController.add(
              RemoteMessage(data: data),
            );
          } catch (_) {
            _onMessageStreamController.add(
              RemoteMessage(
                data: {
                  'payload': response.payload,
                },
              ),
            );
          }
        }
      },
    );

    // ==========================================================
    // 🔕 GENERAL CHANNEL
    // ==========================================================

    const AndroidNotificationChannel generalChannel =
    AndroidNotificationChannel(
      generalChannelId,
      generalChannelName,
      description: 'General application notifications',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // ==========================================================
    // ANDROID PLUGIN
    // ==========================================================

    final AndroidFlutterLocalNotificationsPlugin?
    androidPlugin =
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // ==========================================================
    // CREATE GENERAL CHANNEL
    // ==========================================================

    await androidPlugin?.createNotificationChannel(
      generalChannel,
    );

    // ==========================================================
    // DOWNLOAD CHANNEL
    // ==========================================================

    const AndroidNotificationChannel downloadChannel =
    AndroidNotificationChannel(
      downloadChannelId,
      downloadChannelName,
      description:
      'Progress and status notifications for file downloads',
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
    );

    await androidPlugin?.createNotificationChannel(
      downloadChannel,
    );

    print('========================================');
    print('Notification channels initialized');
    print('🔕 General Channel ID: $generalChannelId');
    print('📥 Download Channel ID: $downloadChannelId');
    print('========================================');
  }

  // ============================================================
  // CANCEL ALL NOTIFICATIONS
  // ============================================================

  static Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();

    print('🔔 All notifications cancelled.');
  }

  // ============================================================
  // SHOW LOCAL NOTIFICATION
  // ============================================================

  static Future<void> showLocalNotification(
      RemoteMessage message,
      ) async {
    // Skip manual local notification on iOS
    if (Platform.isIOS) {
      return;
    }

    final Map<String, dynamic> data = message.data;

    // ==========================================================
    // TITLE & BODY
    // ==========================================================

    final String title = message.notification?.title ??
        data['title']?.toString() ??
        'New Order Assignment';

    final String body = message.notification?.body ??
        data['body']?.toString() ??
        data['message']?.toString() ??
        'You have a new order assignment';

    print('========================================');
    print('📩 Incoming Notification Display');
    print('🔔 Title: $title');
    print('📝 Body: $body');
    print('📦 Data: $data');
    print('🔕 General notification - normal sound');
    print('========================================');

    // ==========================================================
    // IMAGE
    // ==========================================================

    final String? imageUrl =
        message.notification?.android?.imageUrl ??
            message.notification?.apple?.imageUrl ??
            data['image']?.toString() ??
            data['image_url']?.toString();

    BigPictureStyleInformation? bigPictureStyleInformation;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final String filePath = await _downloadAndSaveImage(
          imageUrl,
          'notif_img_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(filePath),
          contentTitle: title,
          summaryText: body,
        );
      } catch (e) {
        print(
          '❌ Failed to download notification image: $e',
        );
      }
    }

    // ==========================================================
    // GENERAL CHANNEL
    // ==========================================================

    const String channelId = generalChannelId;
    const String channelName = generalChannelName;

    // ==========================================================
    // ANDROID NOTIFICATION DETAILS
    // ==========================================================

    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'General application notifications',

      // Normal notification importance & priority
      importance: Importance.high,
      priority: Priority.high,

      // Default notification sound
      playSound: true,

      // Normal vibration
      enableVibration: true,
      enableLights: true,

      color: const Color(0xFFFA6624),

      // Normal notification category
      category: AndroidNotificationCategory.status,

      // Normal notification audio attributes
      audioAttributesUsage:
      AudioAttributesUsage.notification,

      autoCancel: true,
      ongoing: false,
      fullScreenIntent: false,

      styleInformation:
      bigPictureStyleInformation ??
          const DefaultStyleInformation(
            true,
            true,
          ),
    );

    final NotificationDetails platformDetails =
    NotificationDetails(
      android: androidDetails,
    );

    // ==========================================================
    // PAYLOAD
    // ==========================================================

    String? payloadString;

    try {
      payloadString = jsonEncode(data);
    } catch (_) {
      payloadString = data['payload']?.toString();
    }

    // ==========================================================
    // NOTIFICATION ID
    // ==========================================================

    final int notificationId =
    DateTime.now().millisecondsSinceEpoch.remainder(100000);

    // ==========================================================
    // SHOW NOTIFICATION
    // ==========================================================

    try {
      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        platformDetails,
        payload: payloadString,
      );
    } on PlatformException catch (e) {
      print(
        '⚠️ PlatformException showing notification: $e',
      );

      print(
        '🔄 Falling back to default notification settings...',
      );

      // ========================================================
      // FALLBACK DETAILS
      // ========================================================

      final AndroidNotificationDetails
      fallbackAndroidDetails =
      AndroidNotificationDetails(
        generalChannelId,
        generalChannelName,
        channelDescription: 'General Notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        color: const Color(0xFFFA6624),
        autoCancel: true,
        ongoing: false,
        fullScreenIntent: false,
        styleInformation:
        bigPictureStyleInformation ??
            const DefaultStyleInformation(
              true,
              true,
            ),
      );

      final NotificationDetails fallbackDetails =
      NotificationDetails(
        android: fallbackAndroidDetails,
      );

      try {
        await _flutterLocalNotificationsPlugin.show(
          notificationId,
          title,
          body,
          fallbackDetails,
          payload: payloadString,
        );
      } catch (fallbackError) {
        print(
          '❌ Failed to show fallback notification: '
              '$fallbackError',
        );
      }
    } catch (e) {
      print('❌ Error showing notification: $e');
    }
  }

  // ============================================================
  // NOTIFICATION LISTENER
  // ============================================================

  static void initNotificationListener() {
    // ==========================================================
    // 1. TERMINATED STATE
    // ==========================================================

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print(
          '📲 App launched from terminated state via '
              'notification: ${message.data}',
        );

        _onMessageStreamController.add(message);
      }
    }).catchError((e) {
      print(
        '⚠️ Error checking initial FCM message: $e',
      );
    });

    // ==========================================================
    // 2. FOREGROUND STATE
    // ==========================================================

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        print(
          '📩 Foreground FCM message received: '
              '${message.messageId}',
        );

        print(
          '🔔 Title: '
              '${message.notification?.title ?? message.data['title']}',
        );

        print('📦 Data: ${message.data}');

        // Show normal local notification
        showLocalNotification(message);

        // Notify UI subscribers
        _onMessageStreamController.add(message);
      },
    );

    // ==========================================================
    // 3. BACKGROUND STATE
    // ==========================================================

    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        print(
          '📲 Notification opened by user: ${message.data}',
        );

        _onMessageStreamController.add(message);
      },
    );

    // ==========================================================
    // 4. TOKEN REFRESH LISTENER
    // ==========================================================

    FirebaseMessaging.instance.onTokenRefresh.listen(
          (String newToken) async {
        print(
          '🔄 FCM Token refreshed: $newToken',
        );

        await SessionManager.saveFirebaseToken(
          newToken,
        );

        _onTokenRefreshStreamController.add(
          newToken,
        );
      },
    );
  }

  // ============================================================
  // DOWNLOAD NOTIFICATION IMAGE
  // ============================================================

  static Future<String> _downloadAndSaveImage(
      String url,
      String fileName,
      ) async {
    final Directory directory =
    await getApplicationDocumentsDirectory();

    final String filePath =
        '${directory.path}/$fileName';

    final http.Response response =
    await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download image: ${response.statusCode}',
      );
    }

    final File file = File(filePath);

    await file.writeAsBytes(
      response.bodyBytes,
    );

    return filePath;
  }

  // ============================================================
  // DOWNLOAD PROGRESS & COMPLETION NOTIFICATIONS
  // ============================================================

  static Future<void> showDownloadProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required int maxProgress,
  }) async {
    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      downloadChannelId,
      downloadChannelName,
      channelDescription:
      'Progress and status notifications for file downloads',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
      onlyAlertOnce: true,
      ongoing: true,
      autoCancel: false,
    );

    final NotificationDetails notificationDetails =
    NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  // ============================================================
  // DOWNLOAD COMPLETE NOTIFICATION
  // ============================================================

  static Future<void> showDownloadCompleteNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      generalChannelId,
      generalChannelName,
      channelDescription:
      'Download complete notifications',
      importance: Importance.high,
      priority: Priority.high,
      autoCancel: true,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // ============================================================
  // CANCEL SINGLE NOTIFICATION
  // ============================================================

  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}