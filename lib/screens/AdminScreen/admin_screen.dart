import 'package:crmproject/screens/AdminScreen/admin_screen_controller.dart';
import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:crmproject/screens/SignUpScreen/sign_up_screen.dart';
import 'package:crmproject/utils/widgets/custom_list_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          child: Obx(
            ()=> Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 10,
                children: [
                  Text("Employees",style: TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.employees.length,
                      itemBuilder: (context, index) {
                        final employee = controller.employees[index];
                        return CustomListCard(user: employee, controller: controller,);
                      },
                    ),
                  Text("Users",style: TextStyle(
                      fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),),

              ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.users.length,
                    itemBuilder: (context, index) {
                      final user = controller.users[index];
                      return CustomListCard(user: user, controller: controller);
                    },
                  ),

                ],
              ),
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
