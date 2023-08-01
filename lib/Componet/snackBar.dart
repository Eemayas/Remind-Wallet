import 'package:flutter/material.dart';

import '../constant.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> CustomSnackbar({
  context,
  icons = Icons.error,
  iconsColor = Colors.red,
  text,
  backgroundColor = kBackgroundColorCard,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: backgroundColor,
        content: Row(
          children: [
            Icon(icons, color: iconsColor),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: kwhiteTextStyle,
            ),
          ],
        )),
  );
}
