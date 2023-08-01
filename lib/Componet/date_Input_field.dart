// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

class DateInputField extends StatelessWidget {
  const DateInputField({
    super.key,
    this.isEnable = true,
    required this.controllerss,
    required this.keyboardType,
    required this.labelText,
    required this.prefixIcon,
    required this.hintText,
  });
  final String hintText;
  final TextEditingController controllerss;
  final TextInputType keyboardType;
  final String labelText;
  final bool isEnable;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    controllerss.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return TextField(
      enabled: isEnable,
      controller: controllerss,
      cursorColor: Colors.white,
      style: kwhiteTextStyle,
      keyboardType: keyboardType,
      readOnly: true,
      onTap: () => {
        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(3000))
            .then((value) => controllerss.text = DateFormat('yyyy-MM-dd').format(value ?? DateTime.now())),
      },
      decoration: InputDecoration(
        labelStyle: kwhiteTextStyle,
        filled: true,
        hintStyle: ksubTextStyle,
        fillColor: kBackgroundColorCard,
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: controllerss.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                icon: Icon(Icons.close),
                color: Colors.red,
                onPressed: () => controllerss.clear(),
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
