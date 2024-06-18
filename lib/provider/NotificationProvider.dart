import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapfood_v2/main.dart';
import 'package:tapfood_v2/model/General.dart';
import 'package:tapfood_v2/screen/Order/OrderDetailPage.dart';
import 'package:tapfood_v2/services/TokenServices.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  print('Handling a background message ${message.notification?.body} ${message.notification.hashCode} ${message.notification?.title}');
  NotificationProvider().showNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

class NotificationProvider extends ChangeNotifier{
  TokenServices tokenServices = TokenServices();

  initNotification() async{
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload = notificationAppLaunchDetails!.payload;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('logo');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
            ) async {
          didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
          if (payload != null && payload != 0){
            navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => OrderDetailPage()));
          }
        });
  }

  Future<bool> setToken() async{
    final prefs = await SharedPreferences.getInstance();

    try{
      FirebaseMessaging.instance.getToken().then((value) {
        print(value.toString());
        if(prefs.getString("FcmToken") != value.toString()) {
          if(prefs.getString("FcmToken") != null){
            tokenServices.deleteToken(prefs.getString("FcmToken").toString());
          }

          prefs.setString("FcmToken", value.toString());
          tokenServices.insertToken(value.toString());
        }
      });

      FirebaseMessaging.onMessage.listen(showForegroundNotification);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> removeToken() async{
    final prefs = await SharedPreferences.getInstance();
    bool isSuccess = false;

    try{
      isSuccess = await tokenServices.deleteToken(prefs.getString("FcmToken").toString());

      notifyListeners();
    }catch(e){
      isSuccess = false;
    }

    return isSuccess;
  }

  showForegroundNotification(RemoteMessage remoteMessage) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString("FcmToken") != null){
      RemoteNotification? notification = remoteMessage.notification;

      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'high_importance_channel', 'your channel name',
          sound: RawResourceAndroidNotificationSound("foreground_notification_sound"),
          importance: Importance.max,
          priority: Priority.high,
          playSound: true);
      var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          platformChannelSpecifics,
          payload: ""
      );
    }
  }

  showNotification(RemoteMessage remoteMessage) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString("FcmToken") != null){
      RemoteNotification? notification = remoteMessage.notification;

      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'high_importance_channel', 'your channel name',
          sound: RawResourceAndroidNotificationSound("notification_sound"),
          importance: Importance.max,
          priority: Priority.high,
          playSound: true);
      var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          platformChannelSpecifics,
          payload: ""
      );
    }
  }
}