import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SaveButton extends StatelessWidget {

  final VoidCallback onPressed;
  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        fixedSize: Size(350, 40),
      ),
        onPressed: (){
       onPressed();
      Get.snackbar('saves data', "your data is saved");
    }, child: Text("Save",style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white
    ),));
  }
}
