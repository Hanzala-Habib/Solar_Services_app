
import 'package:crmproject/screens/AdminScreen/admin_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/widgets/custom_list_card.dart';

class EmployeeManagementScreen extends StatelessWidget {
  final AdminController adminController=Get.put(AdminController());
  EmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
        Text("Employees",style: TextStyle(
              fontWeight: FontWeight.bold,
                fontSize: 18
            ),),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:adminController.employees.length,
                itemBuilder: (context, index) {
                  final employee = adminController.employees[index];
                  return CustomListCard(user: employee, controller: adminController,);
                },
              ),
            Text("Users",style: TextStyle(
                fontWeight: FontWeight.bold,
              fontSize: 18
            ),),

        ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:adminController.users.length,
              itemBuilder: (context, index) {
                final user = adminController.users[index];
                return CustomListCard(user: user, controller: adminController);
              },
            ),
        ],
      ),
    );
  }
}
