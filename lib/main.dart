import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:admin_navudyojak/firebase_options.dart';
import 'package:admin_navudyojak/src/app.dart';
import 'package:admin_navudyojak/src/configs/injector/injector_conf.dart';
import 'package:admin_navudyojak/src/core/constants/list_translation_locale.dart';
import 'package:admin_navudyojak/src/core/services/notification_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('A bg message just showed up : ${message.messageId}');
  if (message.notification == null) {
    await NotificationService.initLocalNotifications();
    await NotificationService.showLocalNotification(message);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('Firebase / NotificationService init error: $e');
  }

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
