import 'package:crmproject/screens/ClientScreen/client_screen.dart';
import 'package:crmproject/screens/Subscribe%20Servcice/order_confirm_controller.dart';
import 'package:crmproject/screens/UserSubscriptionScreen/user_subscription_controller.dart';
import 'package:crmproject/utils/widgets/save_button.dart';
import 'package:crmproject/utils/widgets/custom_date_time_field.dart';
import 'package:crmproject/utils/widgets/custom_input_field.dart';
import 'package:crmproject/utils/widgets/custom_time_selection_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class OrderScreen extends StatelessWidget {
  final Map<String, dynamic> serviceData;
  final controller = Get.put(OrderController());
  final subscribeController = Get.put(SubscriptionController());

  OrderScreen({super.key, required this.serviceData});

  @override
  Widget build(BuildContext context) {
    print(serviceData);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Order ${serviceData['title']}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          children: [
            CustomInputField(
              label: "Mobile Number",
              keyboardType: TextInputType.phone,
            ),
            CustomTimeSelectionField(
              label: "Select Time",
              controller: controller.timeController,
            ),
            CustomDateField(
              label: "Select Date",
              controller: controller.dateController,
              onChanged: (val) {
                controller.setDate(val!);
              },
            ),


            SaveButton(
              buttonText: "Confirm",
              onPressed: () {
                subscribeController.createRequest(
                  userId: subscribeController.auth.currentUser!.uid,
                  serviceId: serviceData['id'],
                  scheduledDate: controller.scheduledDate,
                  // scheduledTime: controller.timeController.value
                );

                Get.snackbar(
                  "You have Purchased... Confirmed",
                  "Please available on that day out technician with contact you before an hours",
                );
                Get.off(() => ClientScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
