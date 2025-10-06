import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static Future<void> saveTokenToFirestore(String uid) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "fcmToken": token,
      });
    }
  }
}
