
import 'package:crmproject/screens/AdminScreen/admin_screen_controller.dart';
import 'package:crmproject/screens/SignUpScreen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/widgets/custom_list_card.dart';

class EmployeeManagementScreen extends StatelessWidget {
  final AdminController adminController=Get.put(AdminController());
  EmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: Text("Employees",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:adminController.employees.length,
                  itemBuilder: (context, index) {
                    final employee = adminController.employees[index];
                    return CustomListCard(user: employee, controller: adminController,);
                  },
                ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Get.to(()=>SignUpScreen(buttonText: 'Add Employee',));
      },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white,fontWeight:FontWeight.bold,),
      ),
    );
  }
}
