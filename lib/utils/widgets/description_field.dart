import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController? descriptionController;
  final String  hintText;
DescriptionField({super.key, required this.hintText,this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: 20,
      minLines: 4,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: "Description",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
      validator:
              (value) {
            if (value == null || value.trim().isEmpty) {
              return "Description cannot be empty";
            }
            if (value.length < 10) {
              return "Description must be at least 10 characters";
            }
            return null;
          },
    );

  }
}
