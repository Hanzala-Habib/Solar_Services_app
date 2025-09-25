import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ManagerScreen extends StatelessWidget {
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.to(()=>LoginScreen());
                Get.snackbar("Logged Out", "You are logged out");
              },
              icon: const Icon(Icons.logout,color: Colors.white,))
        ],
        title: Text("Manager Screen",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text("Manager Screen"),
      ),
    );
  }
}