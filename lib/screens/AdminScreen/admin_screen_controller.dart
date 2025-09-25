
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();

      final filtered = snapshot.docs
          .map((doc) => {
        "id": doc.id,
        ...doc.data(),
      })
          .where((user) => user["role"] != "Admin")
          .toList();

      users.assignAll(filtered);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateAccess(String uid, bool access) async {
    await _firestore.collection("users").doc(uid).update({"access": access});
    await fetchUsers();
    Get.snackbar("Access Updated", access ? "User allowed " : "User blocked ");
  }


  Future<void> resetPassword(String email) async {
    if (email.trim().isEmpty) {
      Get.snackbar("Error", "No email found");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Password Reset", "Link sent to $email");
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print(e);
    }
  }


  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection("users").doc(uid).delete();
      Get.snackbar("User Deleted", "User removed from system.");
      await fetchUsers();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

