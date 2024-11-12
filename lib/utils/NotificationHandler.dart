import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:homework3/utils/SingleTon.dart';

import 'LocalNotificationHandler.dart';

// top level func only not in class func

Future<void> _handleBackgroundNotification(RemoteMessage message) async {
  log('lisent background :${message.notification!.title}');
  _pushLocalNotification(message);
}

void _handleMessage(RemoteMessage? message) async {
  log("lisent out app");
  if (message == null) return;
  _pushLocalNotification(message);
}

void _handleMessageOnAppOpen(RemoteMessage message) async {
  log("lisent in app");
  _pushLocalNotification(message);
}

void _pushLocalNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;
  var msg = ReceivedNotification(
    title: notification.title,
    body: notification.body,
    payload: jsonEncode(message.toMap()),
  );
  await LocalNotificationHandler.showBigNotification(msg: msg);
}

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class NotificationHandler {
  final _firebaseMsg = FirebaseMessaging.instance;
  final _firebaseOnMessage = FirebaseMessaging.onMessage;
  final _firebaseOnMessageOpenApp = FirebaseMessaging.onMessageOpenedApp;

  Future<void> initNotification() async {
    try {
      var permission = await _firebaseMsg.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (permission.authorizationStatus == AuthorizationStatus.authorized) {
        log('User granted permission');
      } else if (permission.authorizationStatus ==
          AuthorizationStatus.provisional) {
        log('User granted provisional permission');
      } else {
        log('User declined or has not accepted permission');
      }

      await _firebaseMsg.getToken().then((token) {
        log("device token ----------> : $token");
        GlobalClass().deviceId = token!;
      });
      await _subcriptTopic();
      await _initPushNotification();
    } catch (error) {
      log(
        'CatchError while initNotification ( error message ) : >> $error',
      );
    }
  }

  Future<void> _initPushNotification() async {
    await _firebaseMsg.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _firebaseMsg.getInitialMessage().then(_handleMessage);
    _firebaseOnMessageOpenApp.listen(_handleMessage);
    // on while in app
    _firebaseOnMessage.listen(_handleMessageOnAppOpen);
    // on background while app running
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotification);
  }

  Future<void> _subcriptTopic() async {
    await _firebaseMsg.subscribeToTopic('fashion_all');
  }
}
