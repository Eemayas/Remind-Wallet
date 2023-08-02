// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../constant.dart';

class LogoViewer extends StatelessWidget {
  final double side;
  // final double width;
  const LogoViewer({super.key, required this.side});

  @override
  Widget build(BuildContext context) {
    // return Image(
    //   image: AssetImage("assets/app_logo.png"),
    // );
    return Container(
      height: side,
      width: side,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: kMainBoxBorderColor,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: kBoxShadowMainBoxBolor,
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
        ],
        // image: DecorationImage(image: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif')),
        image: DecorationImage(image: AssetImage("assets/Logo/png/logo-white.png"), fit: BoxFit.fill),
      ),
    );
  }
}
