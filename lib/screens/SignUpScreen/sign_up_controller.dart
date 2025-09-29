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
  final adminSelectedRole='Employee'.obs;
  final adminRoles=['Employee','Client'];
  final userRoles = ["Client"];


  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  Future<void> signup(String creator) async {
    try {
      isLoading.value = true;
      final user = await _authRepository.registerWithEmail(
          nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        selectedRole.value

      );
      if (user != null) {
        if (selectedRole.value == "Client" && creator!='Admin') {
          Get.offAllNamed("/ClientScreen");
        } else if (selectedRole.value ==" Admin"){
          Get.offAllNamed("/adminScreen");
        } else if (selectedRole.value == "Employee" && creator!='Admin') {
          Get.offAllNamed("/EmployeeScreen");
        }else{
          Get.offAllNamed("/adminScreen");
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