import 'package:crmproject/screens/ClientScreen/client_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Employee Screen",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold

        ),),
        actions: [
          IconButton(onPressed: ()async{

            Get.to(()=>ClientProfileScreen(dbname: 'users',));
          }, icon: Icon(Icons.settings,color: Colors.white,))
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text("Employee"),
      ),
    );
  }
}
