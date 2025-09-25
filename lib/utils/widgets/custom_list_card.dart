import 'package:crmproject/screens/ClientScreen/client_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListCard extends StatelessWidget {
  final user;
  final controller;
  final String dbName;

  const CustomListCard({super.key,required this.user,required this.controller,this.dbName='users'});

  @override
  Widget build(BuildContext context) {
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
              controller.updateAccess(user["id"], true,dbName);
            } else if (val == "Block") {
              controller.updateAccess(user["id"], false,dbName);
            } else if (val == "Reset Password") {
              controller.resetPassword(user["email"]);
            } else if (val == "Delete") {
              controller.deleteUser(user["id"],dbName);
            }
            else if(val == 'update Address'){
              Get.to(()=>ClientProfileScreen(name: user['name'],dbname: dbName,));

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
  }
}
