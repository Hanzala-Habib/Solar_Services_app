import 'package:crmproject/data/repository/auth_repository.dart';
import 'package:crmproject/screens/EmployeeManagement/employee_management_screen.dart';
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
      final roleToSave = (creator == 'Admin')
          ? adminSelectedRole.value
          : selectedRole.value;
      final user = await _authRepository.registerWithEmail(
          nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        roleToSave
      );
      if (user != null) {
        if (selectedRole.value == "Client" && creator!='Admin') {
          Get.offAllNamed("/ClientScreen");
        }else if (adminSelectedRole.value == "Employee" && creator=='Admin') {
          print("role in signup ${creator} and adminselcted role is ${roleToSave}");
          Get.off(()=>EmployeeManagementScreen());
        }
        else{
          Get.offAllNamed("/adminScreen");
        }
        // else if (selectedRole.value ==" Admin"){
        //   Get.offAllNamed("/adminScreen");
        // }

        Get.snackbar("Success", "Account created for ${user.email}");
      }
    } catch (e) {

      Get.snackbar('Error', e.toString(),);
    } finally {
      isLoading.value = false;
    }
  }

}