import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;

  Future<void> deleteService(String id) async{
    await _firestore.collection('services').doc(id).delete();
    Get.snackbar("Deleted", "Service removed successfully");
}
  Future<void> saveService() async {
    try {
      // DocumentReference docRef =
      await _firestore.collection("services").add({
        "title": titleController.text.trim(),
        "price": double.tryParse(priceController.text.trim()) ?? 0.0,
        "description": descriptionController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });
      // await docRef.update(<String, dynamic>{
      //   "id": docRef.id,
      // });

      Get.snackbar("Success", "Service saved successfully");
      clearFields();
    } catch (e) {
      Get.snackbar(" Error", e.toString());
    }
  }

  void clearFields() {
    titleController.clear();
    priceController.clear();
    descriptionController.clear();
  }
}
