import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {

  static void handleMessage(RemoteMessage message, BuildContext context) {
    if (message.notification != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification!.title ?? "Notification"),
          content: Text(message.notification!.body ?? "No Body"),
        ),
      );
    }
  }
}
