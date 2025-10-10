import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static Future<void> saveTokenToFirestore(String uid) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    final fireStore = FirebaseFirestore.instance;


    final userDoc = await fireStore.collection('users').doc(uid).get();


    if (userDoc.exists) {
      await fireStore.collection("users").doc(uid).set({
        "fcmToken": token,
      }, SetOptions(merge: true));

    } else {
      await fireStore.collection('Employees').doc(uid).set({
        "fcmToken": token,
      },SetOptions(merge: true));
      print("✅ user saved in Employee collection");
    }
  }
}
