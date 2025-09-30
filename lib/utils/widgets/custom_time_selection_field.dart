import 'package:flutter/material.dart';

class CustomTimeSelectionField extends StatefulWidget {
  final String label;
  final ValueChanged<TimeOfDay?>? onChanged;
  final TextEditingController controller;

  const CustomTimeSelectionField({
    super.key,
    required this.label,
    this.onChanged,
    required this.controller,
  });

  @override
  State<CustomTimeSelectionField> createState() => _SimpleTimeFieldState();
}

class _SimpleTimeFieldState extends State<CustomTimeSelectionField> {
  TimeOfDay? selectedTime;

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        widget.controller.text = picked.format(context);
      });
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        TextField(
          controller: widget.controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: '12:00 am',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.access_time),
              onPressed: _pickTime,
            ),
          ),
        ),
      ],
    );
  }
}
