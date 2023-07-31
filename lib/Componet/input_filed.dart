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
    this.isrequired = false,
  });
  final String hintText;
  final TextEditingController Controllerss;
  final TextInputType keyboardType;
  final String labelText;
  final IconData prefixIcon;
  final bool isrequired;
  // String capitalizeFirstLetter(String text) {
  //   if (text == null || text.isEmpty) {
  //     return '';
  //   }
  //   return text[0].toUpperCase() + text.substring(1);
  // }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: Controllerss,
      // onChanged: (text) {
      //   Controllerss.value = Controllerss.value.copyWith(
      //     text: capitalizeFirstLetter(text),
      //     selection: TextSelection.collapsed(offset: Controllerss.text.length),
      //   );
      // },
      validator: (value) {
        // if (isrequired) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
        // }
      },
      cursorColor: Colors.white,
      style: kwhiteTextStyle,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelStyle: kwhiteTextStyle,
        filled: true,
        // errorText: Controllerss.text.isEmpty && isrequired
        //     ? "This cannot be empty"
        //     : null,
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
