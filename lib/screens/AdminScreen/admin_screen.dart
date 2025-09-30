import 'package:crmproject/screens/AdminScreen/admin_screen_controller.dart';
import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:crmproject/screens/SignUpScreen/sign_up_screen.dart';
import 'package:crmproject/screens/Service%20Screen/create_service_screen.dart';
import 'package:crmproject/utils/widgets/admin_services_card.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Subscription Screen/create_subscription_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.put(AdminController());

    controller.fetchUsers();
    controller.fetchEmployees();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.to(()=>LoginScreen());
                Get.snackbar("Logged Out", "You are logged out");
              },
              icon: const Icon(Icons.logout,color: Colors.white,))
        ],
      ),
      body:SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 10,
                children: [
                  AdminServicesCard(onPressed: (){
                    Get.to(()=>CreateServiceScreen());
                  },
                  cardtext: "Create and manage Services",),
                  AdminServicesCard(onPressed: (){
                    Get.to(()=>CreateSubscriptionScreen());
                  },
                    cardtext: "Create Subscription for users",),
                  AdminServicesCard(onPressed: (){
                    Get.to(()=>CreateSubscriptionScreen());
                  },

                    cardtext: "Manage Employees",),
                  AdminServicesCard(onPressed: (){
                    Get.to(()=>CreateSubscriptionScreen());
                  },
                    cardtext: "Client Management",),

                ],
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const SignUpScreen(buttonText: "Create User"));
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
