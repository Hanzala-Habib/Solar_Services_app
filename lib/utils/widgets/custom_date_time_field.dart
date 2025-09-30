import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatefulWidget {
  final String label;
  final ValueChanged<DateTime?>? onChanged;
  final TextEditingController? controller;

  const CustomDateField({
    super.key,
    required this.label,
    this.onChanged,
    this.controller,
  });

  @override
  _CustomDatePickerFieldState createState() {
    return _CustomDatePickerFieldState();
  }
}

class _CustomDatePickerFieldState extends State<CustomDateField> {
  DateTime? selectedDate;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _controller.text = DateFormat("yyyy-MM-dd").format(picked);
      });
      widget.onChanged?.call(picked);
    }
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please select a date";
    }

    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$'); // yyyy-MM-dd strict
    if (!regex.hasMatch(value)) {
      return "Invalid format (use yyyy-MM-dd)";
    }

    try {
      DateFormat("yyyy-MM-dd").parseStrict(value);
    } catch (_) {
      return "Invalid date";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          cursorColor: Colors.black,
          validator: _validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TextInputFormatter.withFunction((oldValue, newValue) {
              String text = newValue.text;


              if (text.length > 4 && text[4] != '-') {
                text = '${text.substring(0, 4)}-${text.substring(4)}';
              }
              if (text.length > 7 && text[7] != '-') {
                text = '${text.substring(0, 7)}-${text.substring(7)}';
              }
              if (text.length > 10) {
                text = text.substring(0, 10);
              }

              return TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: text.length),
              );
            }),
          ],
          decoration: InputDecoration(
            hintText: 'yyyy-MM-dd',
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
          onChanged: (value) {
            try {
              final parsedDate =
              DateFormat("yyyy-MM-dd").parseStrict(value.trim());
              setState(() {
                selectedDate = parsedDate;
              });
              widget.onChanged?.call(parsedDate);
            } catch (_) {
              // validator will show error
            }
          },
        ),
      ],
    );
  }
}
