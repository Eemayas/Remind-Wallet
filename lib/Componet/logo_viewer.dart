// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../constant.dart';

class LogoViewer extends StatelessWidget {
  final double side;
  // final double width;
  const LogoViewer({super.key, required this.side});

  @override
  Widget build(BuildContext context) {
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
        image: DecorationImage(image: AssetImage("assets/Logo/png/logo-white.png"), fit: BoxFit.fill),
      ),
    );
  }
}
