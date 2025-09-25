import 'package:crmproject/screens/AdminScreen/admin_screen_controller.dart';
import 'package:crmproject/screens/ClientScreen/client_screen.dart';
import 'package:crmproject/screens/ClientScreen/client_screen_controller.dart';
import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:crmproject/utils/widgets/Save_button.dart';
import 'package:crmproject/utils/widgets/custom_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientProfileScreen extends StatelessWidget {
  final ClientProfileController clientProfileController=Get.put(ClientProfileController());
  final AdminController adminController=Get.put(AdminController());
  final String name;
  final _auth = FirebaseAuth.instance;
 ClientProfileScreen({super.key,this.name='SNM Products'});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(onPressed: (){
            Get.to(()=>LoginScreen());
            Get.snackbar("Logged Out", "You are logged out");
          }, icon: Icon(Icons.logout,color: Colors.white,))
        ],
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
     


      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            CustomInputField(
              label: 'Address',
              controller: clientProfileController.addressController,
            ),
            CustomInputField(
              label: "Mobile Number",
              controller: clientProfileController.mobileController,
            ),
            RichText(text: TextSpan(
              text: "Reset Password",
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = (){


                  final email =_auth.currentUser?.email;
                  if (email != null) {
                    adminController.resetPassword(email);
                  } else {
                    Get.snackbar("Error", "No email found for this user");
                  }
                }

            )),
            SaveButton(
              onPressed: () async {
                await clientProfileController.saveClientDetails();
                Get.offAll(() =>  ClientScreen(title: 'Client Products',));
              },
            ),
          ],
        ),
      ),
    );
  }
}

