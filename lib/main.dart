import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:admin_navudyojak/src/app.dart';
import 'package:admin_navudyojak/src/configs/injector/injector_conf.dart';
import 'package:admin_navudyojak/src/core/constants/list_translation_locale.dart';
import 'package:admin_navudyojak/src/core/services/notification_service.dart';
import 'package:admin_navudyojak/src/core/session/session_manager.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('dotenv load warning: $e');
  }

  await EasyLocalization.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // Initialize GETIt service locators
  configureDepedencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        englishLocale,
        marathiLocale,
        hindiLocale,
        Locale('en'),
        Locale('mr'),
        Locale('hi'),
      ],
      path: "assets/lang",
      fallbackLocale: englishLocale,
      startLocale: englishLocale,
      useOnlyLangCode: true,
      child: const MyApp(),
    ),
  );
}
