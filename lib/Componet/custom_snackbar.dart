// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../constant.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackbar({
  required BuildContext context,
  icons = Icons.error,
  iconsColor = Colors.red,
  text,
  backgroundColor = kBackgroundColorCard,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: kBackgroundColorCard,
        content: Row(
          children: [
            Icon(icons, color: iconsColor),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.77,
              child: Text(
                text,
                softWrap: true,
                style: kwhiteTextStyle,
              ),
            ),
          ],
        )),
  );
}
