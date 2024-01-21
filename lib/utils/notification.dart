import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService{
  void initAwesomeNotification() async {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'key1',
            channelName: 'MotoMate',
            channelDescription: 'Testing Notification',
            defaultColor: Colors.orangeAccent,
            ledColor: Colors.orangeAccent,
            //soundSource: 'assets/notification.mp3',
            enableLights: true,
            enableVibration: true,
            playSound: true,
          )
        ]
    );
  }

  void requestPermission() async {
    AwesomeNotifications().isNotificationAllowed().then((allowed) {
      if (!allowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void pushNotification(String message) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: 'MotoMate',
          body: message,
        ));
  }
}