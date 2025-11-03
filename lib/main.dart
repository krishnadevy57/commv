import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'services/storage_service.dart';
import 'controllers/theme_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'themes/themes.dart';

// 🔔 Background message handler (must be top-level function)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('📩 Background message received: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Initialize storage service
  final storageService = StorageService.instance;
  await storageService.init();
  Get.put(storageService);

  // ✅ Initialize notifications
  await _setupFirebaseMessaging();

  runApp(CommVApp());
}

Future<void> _setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // ✅ Request permission for iOS and Android 13+
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  print('🔐 Notification permission: ${settings.authorizationStatus}');

  // ✅ Get token
  String? token = await messaging.getToken();
  print('🔥 FCM Token: $token');
  StorageService.instance.saveFcmDeviceToken(token ?? "");
  // ✅ Listen to token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print('🔁 Token refreshed: $newToken');
    StorageService.instance.saveFcmDeviceToken(newToken ?? "");

  });

  // ✅ Foreground message listener
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📱 Foreground message received!');
    print('➡️ Title: ${message.notification?.title}');
    print('➡️ Body: ${message.notification?.body}');
  });

  // ✅ When app opened via notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🚀 App opened from notification!');
    print('➡️ Title: ${message.notification?.title}');
  });
}

class CommVApp extends StatelessWidget {
  CommVApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      title: 'CommV',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.theme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    ));
  }
}
