// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../constant.dart';

class CustomProgressButton extends StatelessWidget {
  final String label;
  final double height;
  final double maxWidth;
  final IconData icons;
  final Color iconColor;
  final Function? onTap;
  const CustomProgressButton({
    super.key,
    required this.label,
    this.height = 40.00,
    this.maxWidth = 200.00,
    required this.icons,
    this.iconColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressButton.icon(
        textStyle: kwhiteTextStyle,
        height: height,
        maxWidth: maxWidth,
        iconedButtons: {
          ButtonState.idle: IconedButton(
            text: label,
            icon: Icon(icons, color: iconColor),
            color: Colors.deepPurple.shade500,
          ),
          ButtonState.loading: IconedButton(text: "Loading", color: Colors.deepPurple.shade700),
          ButtonState.fail: IconedButton(text: "Failed", icon: Icon(Icons.cancel, color: Colors.white), color: Colors.red.shade300),
          ButtonState.success: IconedButton(
              text: "Success",
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400)
        },
        onPressed: onTap);
  }
}
