
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  var users = <Map<String, dynamic>>[].obs;
  var employees = <Map<String, dynamic>>[].obs;

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

  Future<void> fetchEmployees() async {
    try {
      final snapshot = await _firestore.collection('Employees').get();

      final filtered = snapshot.docs
          .map((doc) => {
        "id": doc.id,
        ...doc.data(),
      }).toList();
      employees.assignAll(filtered);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateAccess(String uid, bool access,String collection) async {
    await _firestore.collection(collection).doc(uid).update({"access": access});
   if(collection=='Employees'){
     await fetchUsers();
   }else{
     await fetchEmployees();
   }
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


  Future<void> deleteUser(String uid,String collection) async {
    try {
      await _firestore.collection(collection).doc(uid).delete();
      Get.snackbar("User Deleted", "User removed from system.");
      if(collection!='Employee'){
        await fetchUsers();


      }else{
        await fetchEmployees();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

