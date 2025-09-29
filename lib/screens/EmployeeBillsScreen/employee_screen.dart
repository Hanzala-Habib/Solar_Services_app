import 'package:crmproject/screens/EmployeeBillsScreen/employee_screen_controller.dart';
import 'package:crmproject/utils/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeScreen extends StatelessWidget {
  final BillController controller = Get.put(BillController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employee Bills")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            children: [
              CustomInputField(label: "Bill Amount",controller: controller.amountController,),
              CustomInputField(label: "Bill number",controller: controller.numberController,),
              CustomInputField(label: "Bill Name",controller: controller.nameController,),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(350, 40)
                ),
                onPressed: () => controller.pickImage(context),
                child: Text("Upload Bill Image"),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: controller.getEmployeeBills(controller.userId),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Center(child: Text("Upload your bills"));
                    }
                    final bills = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: bills.length,
                      itemBuilder: (context, index) {
                        final bill = bills[index];
                        return Card(
                          child: ListTile(
                            leading: Image.network(bill["billUrl"], width: 50, fit: BoxFit.cover),
                            title: Text("${bill["billName"]} - ${bill["billAmount"]}"),
                            subtitle: Text("Status: ${bill["status"]}"),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == "delete") {
                                  controller.deleteBill(bill.id, bill["billUrl"]);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(value: "delete", child: Text("Delete")),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
