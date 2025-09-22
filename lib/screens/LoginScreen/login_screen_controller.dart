import 'package:crmproject/data/repository/auth_repository.dart';
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

        Get.snackbar("Welcome", "Logged in as $role");

        if (role == "Client") {
          Get.offAllNamed("/ClientScreen");
        } else if (role == "Manager") {
          Get.offAllNamed("/ManagerScreen");
        } else if (role == "Admin"){
          Get.offAllNamed("/adminScreen");
        }else{
          Get.offAllNamed("/ResellerScreen");
        }
      }
    } catch (e) {
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
