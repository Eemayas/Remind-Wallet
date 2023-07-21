import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

class DateInputField extends StatelessWidget {
  const DateInputField({
    super.key,
    required this.Controllerss,
    required this.keyboardType,
    required this.labelText,
    required this.prefixIcon,
    required this.hintText,
  });
  final String hintText;
  final TextEditingController Controllerss;
  final TextInputType keyboardType;
  final String labelText;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    Controllerss.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return TextField(
      controller: Controllerss,
      cursorColor: Colors.white,
      style: kwhiteTextStyle,
      keyboardType: keyboardType,
      readOnly: true,
      onTap: () => {
        showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(3000))
            .then((value) =>
                Controllerss.text = DateFormat('yyyy-MM-dd').format(value!)),
      },
      decoration: InputDecoration(
        labelStyle: kwhiteTextStyle,
        filled: true,
        hintStyle: ksubTextStyle,
        fillColor: kBackgroundColorCard,
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: Controllerss.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                icon: Icon(Icons.close),
                color: Colors.red,
                onPressed: () => Controllerss.clear(),
              ),
        prefixIconColor: Colors.white,
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
