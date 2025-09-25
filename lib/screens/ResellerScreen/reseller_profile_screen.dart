
import 'package:crmproject/screens/ClientScreen/client_screen.dart';
import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:crmproject/screens/ResellerScreen/reseller_screen_controller.dart';
import 'package:crmproject/utils/widgets/Save_button.dart';
import 'package:crmproject/utils/widgets/custom_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResellerScreen extends StatelessWidget {
  const ResellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResellerController controller = Get.put(ResellerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reseller Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        actions: [
          IconButton(
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();

              Get.to(() => LoginScreen());
            },
            icon: const Icon(Icons.login, color: Colors.white),
          )
        ],

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your Details to proceed further",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            CustomInputField(
              label: 'Company Name',
              controller: controller.companyNameController,
            ),
            CustomInputField(
              label: 'Address',
              controller: controller.addressController,
            ),
            CustomInputField(
              label: "Mobile Number",
              controller: controller.mobileController,
            ),
            SaveButton(
              onPressed: () async {
                await controller.saveResellerDetails();
                Get.offAll(() =>  ClientScreen(title: 'Reseller Products',));
              },
            ),
          ],
        ),
      ),
    );
  }
}
