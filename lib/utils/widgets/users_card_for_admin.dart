import 'package:crmproject/utils/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';


class UsersCardForAdmin extends StatelessWidget {
  const UsersCardForAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("User Name",style: TextStyle(
            fontWeight: FontWeight.w600
          ),),
          SizedBox(
            width: 100,
            child: CustomDropdown( value: 'Delete', items:['Delete','access','reset Password'], onChanged: (val){

            }),
          )

        ],
      ),
    );
  }
}
