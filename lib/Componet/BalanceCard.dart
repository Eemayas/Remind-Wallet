// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../constant.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard(
      {super.key, required this.cardName, required this.cardBalanceAmt});
  final String cardName;
  final String cardBalanceAmt;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBackgroundColorCard,
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
        borderRadius: BorderRadius.circular(30),
      ),
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cardName,
                  style: ksubTextStyle.copyWith(
                      fontSize: 12, fontWeight: FontWeight.w300)),
              SizedBox(
                height: 10,
              ),
              Text(cardBalanceAmt,
                  style: kwhiteTextStyle.copyWith(
                      fontSize: 25, fontWeight: FontWeight.w300)),
            ],
          ),
        ),
      ),
    );
  }
}
