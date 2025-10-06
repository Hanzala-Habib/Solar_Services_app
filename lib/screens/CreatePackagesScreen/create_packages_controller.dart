

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackagesController extends GetxController{

  final _fireStore=FirebaseFirestore.instance;
  final nameController=TextEditingController();
  final durationController=TextEditingController();
  final priceController=TextEditingController();

  var selectedServices=<String>[].obs;

  var isLoading=false.obs;

  Stream<QuerySnapshot> fetchAllServices(){
    return _fireStore.collection("services").snapshots();
}

Future<void> createPackage()async{
    try{
      isLoading.value=true;
      await _fireStore.collection("packages").add({
        'name':nameController.text,
        'price':int.parse(priceController.text),
        'durationMonths':int.parse(durationController.text),
        'services':selectedServices,
        'createdAt':DateTime.now()
      });

      clearForm();
    }
    catch(e){
      Get.snackbar('Error', e.toString());
    }finally{
      isLoading.value=false;
    }
}


void toggleService(String serviceId){
    if(selectedServices.contains(serviceId)){
      selectedServices.remove(serviceId);
    }else{
      selectedServices.add(serviceId);
      print(serviceId);
    }
}

void clearForm(){

    nameController.clear();
    durationController.clear();
    priceController.clear();
    selectedServices.clear();
}


}