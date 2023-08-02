// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:expenses_tracker/constant.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final Color confirmTextColor;
  final Color cancelTextColor;
  final Color titleTextColor;
  final Color msgTextColor;
  final String cancelText;
  final String confirmText;

  const CustomAlertDialog({
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmTextColor = Colors.blue,
    this.cancelTextColor = Colors.blue,
    this.titleTextColor = Colors.white,
    this.msgTextColor = Colors.white,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: kwhiteTextStyle.copyWith(color: titleTextColor, fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        style: kwhiteTextStyle.copyWith(color: msgTextColor),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            cancelText,
            style: kwhiteTextStyle.copyWith(color: cancelTextColor),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            confirmText,
            style: kwhiteTextStyle.copyWith(color: confirmTextColor),
          ),
        ),
      ],
    );
  }
}
