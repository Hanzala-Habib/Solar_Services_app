import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/models/service_model.dart';

class ClientProfileController extends GetxController {
  final addressController = TextEditingController();
  final mobileController = TextEditingController();

  var address = "".obs;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var services = <ServiceModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }
  void fetchServices() {
    _firestore.collection("services").orderBy("createdAt", descending: true).snapshots().listen((snapshot) {
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> updateAddress(String newAddress,String dbName) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore.collection(dbName).doc(uid).update({
        "address": newAddress,
      });

      address.value = newAddress;
      Get.snackbar("Success", "Address updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> saveClientDetails(String dbname) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore.collection(dbname).doc(uid).set({
        "address": addressController.text.trim(),
        "mobileNumber": mobileController.text.trim(),
      }, SetOptions(merge: true));

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
