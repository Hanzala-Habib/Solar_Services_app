import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResellerController extends GetxController {
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final mobileController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveResellerDetails() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore.collection("users").doc(uid).set({
        "companyName": companyNameController.text.trim(),
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
