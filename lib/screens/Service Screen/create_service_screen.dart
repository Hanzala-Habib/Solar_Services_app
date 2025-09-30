import 'package:crmproject/screens/AdminBillsScreen/admin_bills_screen.dart';
import 'package:crmproject/screens/Service%20Screen/service_screen_controller.dart';
import 'package:crmproject/utils/widgets/Save_button.dart';
import 'package:crmproject/utils/widgets/custom_input_field.dart';
import 'package:crmproject/utils/widgets/description_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CreateServiceScreen extends StatelessWidget {
  final ServiceController serviceController=Get.put(ServiceController());
   CreateServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme:IconThemeData(
          color: Colors.white
        ),
        title: Text("Create Service",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            children: [
              CustomInputField(label: 'Service Title'),
              CustomInputField(label: 'Price',keyboardType: TextInputType.number,),
              DescriptionField(hintText: 'Enter the service description which helps user to better understand......'),
              SaveButton(onPressed: ()=>{serviceController.saveService(),
              Get.to(()=>AdminScreen())})

            ],
          ),
        ),
      ),
    );

  }
}
