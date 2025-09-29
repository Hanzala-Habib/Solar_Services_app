import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class BillController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var bills = <Map<String, dynamic>>[].obs;
  File? selectedImage;
  final String employeeName = "Ali";

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  var isLoading = false.obs;
  final amountController = TextEditingController();
  final numberController = TextEditingController();
  final  nameController = TextEditingController();

  Future<void> pickImage(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      uploadBill(
        userId: userId,
        employeeName: employeeName,
        billImage: selectedImage!,
        billName: nameController.text,
        billAmount:amountController.text,
        billNumber: numberController.text,
      );
    }
  }


  Future<void> uploadBill({
    required String userId,
    required String employeeName,
    required File billImage,
    required String billName,
    required String billAmount,
    required String billNumber,
  }) async {
    try {
      isLoading.value = true;
      final ref = _storage.ref().child("bills/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg");

      await ref.putFile(billImage);
      String downloadUrl = await ref.getDownloadURL();

      await _firestore.collection("bills").add({
        "userId": userId,
        "employeeName": employeeName,
        "billUrl": downloadUrl,
        "billName": billName,
        "billAmount": billAmount,
        "billNumber": billNumber,
        "createdAt": DateTime.now(),
        "status": "pending",
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch Bills for Employee
  Stream<QuerySnapshot> getEmployeeBills(String userId) {
    return _firestore
        .collection("bills")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// Fetch Bills for Admin
  Stream<QuerySnapshot> getAllBills() {
    return _firestore.collection("bills").orderBy("createdAt", descending: true).snapshots();
  }

  /// Update Bill Status (Admin)
  Future<void> updateBillStatus(String billId, String status) async {
    await _firestore.collection("bills").doc(billId).update({"status": status});
  }

  /// Delete Bill (Employee only his own)
  Future<void> deleteBill(String billId, String imageUrl) async {
    try {
      await _firestore.collection("bills").doc(billId).delete();
      await _storage.refFromURL(imageUrl).delete();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// Download Bill (Admin)
  Future<void> downloadBill(String url, String fileName) async {
    try {
      Dio dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$fileName.jpg";

      await dio.download(url, filePath, onReceiveProgress: (count, total) {
        print("Progress: ${(count / total * 100).toStringAsFixed(0)}%");
      });

      Get.snackbar("Download Complete", "Saved to $filePath");
    } catch (e) {
      Get.snackbar("Error", "Download failed: $e");
    }
  }
}
