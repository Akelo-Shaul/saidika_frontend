import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

// Local Notifications Plugin instance
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> setupFirebaseNotifications() async {
  // Request notification permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Check if user has granted permissions
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
    return;
  }

  // Create an Android notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ID
    'High Importance Notifications', // Title
    description: 'This channel is used for important notifications.', // Description
    importance: Importance.high,
    playSound: true,
  );

  // Initialize local notifications for Android
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/logo');

  // Set initialization settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create the notification channel for Android
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      // Display notification for foreground messages
      showPopupMessage(message.notification!.title, message.notification!.body);
    }
  });

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

void showPopupMessage(String? title, String? body) {
  // Ensure that a unique notification ID is generated for each notification
  int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

  flutterLocalNotificationsPlugin.show(
    notificationId, // Unique ID for each notification
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel', // Channel ID
        'High Importance Notifications', // Channel Name
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        showWhen: true
      ),
    ),
  );
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
}
