import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ClientProfileController extends GetxController {
  final addressController = TextEditingController();
  final mobileController = TextEditingController();
  var name = "".obs;
  var address = "".obs;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final doc = await _firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        name.value = doc["name"] ?? "";
        address.value = doc["address"] ?? "";
      }
    } catch (e) {

    }
  }

  Future<void> updateAddress(String newAddress) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore.collection("users").doc(uid).update({
        "address": newAddress,
      });

      address.value = newAddress;
      Get.snackbar("Success", "Address updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> saveClientDetails() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore.collection("users").doc(uid).set({
        "address": addressController.text.trim(),
        "mobileNumber": mobileController.text.trim(),
        "role": "Reseller",
      }, SetOptions(merge: true));

      Get.snackbar("Success", "Reseller details saved");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
