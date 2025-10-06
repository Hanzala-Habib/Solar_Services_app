import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:crmproject/screens/SignUpScreen/sign_up_controller.dart';
import 'package:crmproject/utils/widgets/custom_drop_down.dart';
import 'package:crmproject/utils/widgets/custom_input_field.dart';
import 'package:crmproject/utils/widgets/custom_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';

import '../../data/services/fcm_service.dart';

class SignUpScreen extends StatefulWidget {
  final String buttonText;

  const SignUpScreen({super.key, this.buttonText = "Sign Up"});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final number = '+923091678178';
  final SignUpController signUpController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,

                children: [
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 110,
                        width: 100,
                        child: Image.asset(
                          'assets/images/snm-logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Image.asset('assets/images/Untitled-3.png'),
                      ),
                    ],
                  ),

                  CustomInputField(
                    label: "Name",
                    controller: signUpController.nameController,
                  ),
                  CustomInputField(
                    label: "Email",
                    controller: signUpController.emailController,
                  ),

                  Obx(
                    () => CustomDropdown(
                      label: "Select your Role",
                      value: widget.buttonText == "Sign Up"
                          ? signUpController.selectedRole.value
                          : signUpController.adminSelectedRole.value,
                      items: widget.buttonText == "Sign Up"
                          ? signUpController.userRoles
                          : signUpController.adminRoles,
                      onChanged: (val) {
                        if (val != null) {
                          signUpController.selectedRole.value = val;
                        }
                      },
                    ),
                  ),
                  Obx(
                    () => CustomPasswordField(
                      label: "Password",
                      controller: signUpController.passwordController,
                      isHidden: signUpController.isPasswordHidden.value,
                      onToggle: signUpController.togglePasswordVisibility,
                    ),
                  ),

                  Obx(
                    () => ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (widget.buttonText == "Create User" ||
                              widget.buttonText == "Add Employee") {
                            signUpController.signup('Admin');
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await FCMService.saveTokenToFirestore(user.uid);
                            }
                          } else {
                            signUpController.signup('User');
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await FCMService.saveTokenToFirestore(user.uid);
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(fixedSize: Size(300, 50)),
                      child: signUpController.isLoading.value
                          ? CircularProgressIndicator()
                          : Text(
                              widget.buttonText,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Already have am account",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      children: [
                        WidgetSpan(child: SizedBox(width: 10)),

                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(LoginScreen());
                            },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call, size: 22),
                      SizedBox(width: 5),
                      RichText(
                        text: TextSpan(
                          text: "0321-8783630",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await FlutterPhoneDirectCaller.callNumber(number);
                              Get.snackbar(
                                "Calling to SNM solutions",
                                "Please wait out support agent will get to you soon",
                              );
                            },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
