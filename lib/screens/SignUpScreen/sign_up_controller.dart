import 'package:crmproject/data/repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class SignUpController extends GetxController{

  final AuthRepository _authRepository=AuthRepository();
  final passwordController = TextEditingController();
  var isPasswordHidden = true.obs;


  var isLoading=false.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final selectedRole = "Client".obs;
  final roles = ["Client", "Manager", "Admin","Reseller"];


  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  Future<void> signup() async {
    try {
      isLoading.value = true;
      final user = await _authRepository.registerWithEmail(
          nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        selectedRole.value

      );
      if (user != null) {
        if (selectedRole.value == "Client") {
          Get.offAllNamed("/ClientScreen");
        } else if (selectedRole.value == "Manager") {
          Get.offAllNamed("/ManagerScreen");
        } else if (selectedRole.value ==" Admin"){
          Get.offAllNamed("/adminScreen");
        }else{
          Get.offAllNamed("/ResellerScreen");
        }
        Get.snackbar("Success", "Account created for ${user.email}");
      }
    } catch (e) {

      Get.snackbar('Error', e.toString(),);
    } finally {
      isLoading.value = false;
    }
  }

}