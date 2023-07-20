import 'package:flutter/material.dart';
import '../constant.dart';

class InputField extends StatelessWidget {
  const InputField({
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
    return TextField(
      controller: Controllerss,
      cursorColor: Colors.white,
      style: kwhiteTextStyle,
      keyboardType: keyboardType,
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
                color: Colors.red,
                icon: Icon(Icons.close),
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
