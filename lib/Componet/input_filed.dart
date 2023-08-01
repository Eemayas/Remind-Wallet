import 'package:flutter/material.dart';
import '../constant.dart';

class InputField extends StatefulWidget {
  const InputField(
      {super.key,
      required this.Controllerss,
      required this.keyboardType,
      required this.labelText,
      required this.prefixIcon,
      required this.hintText,
      this.isrequired = false,
      this.isPassword = false});
  final String hintText;
  final TextEditingController Controllerss;
  final TextInputType keyboardType;
  final String labelText;
  final IconData prefixIcon;
  final bool isrequired;
  final bool isPassword;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.Controllerss,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
        // }
      },
      obscureText: widget.isPassword && !passwordVisible,
      cursorColor: Colors.white,
      style: kwhiteTextStyle,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              )
            : widget.Controllerss.text.isEmpty
                ? Container(width: 0)
                : IconButton(
                    color: Colors.red,
                    icon: Icon(Icons.close),
                    onPressed: () => widget.Controllerss.clear(),
                  ),
        labelStyle: kwhiteTextStyle,
        filled: true,
        hintStyle: ksubTextStyle,
        fillColor: kBackgroundColorCard,
        labelText: widget.labelText,
        prefixIcon: Icon(widget.prefixIcon),
        prefixIconColor: Colors.white,
        hintText: widget.hintText,
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
