import 'package:crmproject/screens/AdminScreen/admin_screen_controller.dart';
import 'package:crmproject/screens/ClientScreen/client_profile_screen.dart';

import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:crmproject/screens/SignUpScreen/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.put(AdminController());

    controller.fetchUsers();

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
      body: Obx(() {
        if (controller.users.isEmpty) {
          return const Center(child: Text("No Users Found"));
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(10.0),
                side: BorderSide(
                  color: user['access']==false ? Colors.redAccent : Colors.white54,
                  width: 2
                )
              ),
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Row(spacing:5,children: [Text(user["name"] ?? "Unknown",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),),Text(user["role"] ?? "Client")]),
                subtitle: Text(user["email"] ?? ""),
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == "Allow") {
                      controller.updateAccess(user["id"], true);
                    } else if (val == "Block") {
                      controller.updateAccess(user["id"], false);
                    } else if (val == "Reset Password") {
                      controller.resetPassword(user["email"]);
                    } else if (val == "Delete") {
                      controller.deleteUser(user["id"]);
                    }
                    else if(val == 'update Address'){
                      Get.to(()=>ClientProfileScreen(name: user['name'],));

                    }

                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: "Allow", child: Text("Allow")),
                    const PopupMenuItem(value: "Block", child: Text("Block")),
                    const PopupMenuItem(value: "Reset Password", child: Text("Reset Password")),
                    const PopupMenuItem(value: "Delete", child: Text("Delete")),
                    const PopupMenuItem(value: "update Address", child: Text("Update Address")),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const SignUpScreen(titleText: "Create User"));
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
