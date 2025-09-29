import 'package:crmproject/screens/EmployeeBillsScreen/employee_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  final BillController controller = Get.put(BillController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin - All Bills")),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getAllBills(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final bills = snapshot.data!.docs;
          return ListView.builder(
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final bill = bills[index];
              return Card(
                child: ListTile(
                  leading: Image.network(bill["billUrl"], width: 50, fit: BoxFit.cover),
                  title: Text("${bill["employeeName"]} - ${bill["billName"]}"),
                  subtitle: Text("Amount: ${bill["billAmount"]}\nStatus: ${bill["status"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () => controller.downloadBill(bill["billUrl"], bill["billName"]),
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => controller.updateBillStatus(bill.id, "approved"),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => controller.updateBillStatus(bill.id, "rejected"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
