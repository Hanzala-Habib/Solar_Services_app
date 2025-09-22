import 'package:flutter/material.dart';
class CustomInputField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  const CustomInputField({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.controller,this.obscureText=false,
  });

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please fill this field";
        }
        return null;
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
