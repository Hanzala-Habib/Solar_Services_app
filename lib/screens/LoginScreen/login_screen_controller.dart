import 'package:crmproject/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    try {
      isLoading.value = true;
      final userData = await _authRepository.loginWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );


      if (userData != null) {
        String role = userData["role"] ?? "Client";
        bool access=userData["access"] ?? true;

        Get.snackbar("Welcome", "Logged in as $role");
        Get.snackbar("Welcome", "access is ${access} approved");

       if(access==true){
         if (role == "Reseller") {
           Get.offAllNamed("/ResellerScreen");
         } else if (role == "Manager") {
           Get.offAllNamed("/ManagerScreen");
         } else if (role == "Admin"){
           Get.offAllNamed("/adminScreen");
         }else{

           Get.offAllNamed("/ClientScreen");
         }
       }else{
         await FirebaseAuth.instance.signOut();
         Get.snackbar("Access Denied", "Your access is blocked by Admin.");
       }
      }
    } catch (e) {
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  void clear(){
    emailController.clear();
    passwordController.clear();
  }
}
