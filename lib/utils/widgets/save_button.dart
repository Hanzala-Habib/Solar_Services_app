import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String buttonText;
  const SaveButton({super.key, required this.onPressed,  this.buttonText='Save'});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        fixedSize: Size(350, 40),
      ),
        onPressed: (){
       onPressed();
    }, child: Text(buttonText,style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white
    ),));
  }
}
