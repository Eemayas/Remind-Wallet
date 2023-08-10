// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../constant.dart';

List<Widget> pagesList = [
  //page 1
  PageFormat(
    animationPath: "assets/lottie/wallet.json",
    labelText: "Remind Wallet",
    subLabelText:
        "Embark on a journey towards financial freedom with our intuitive expense tracker app. Empower your finances by effortlessly recording expenses, planning budgets, and achieving your financial goals.",
  ),
  PageFormat(
    animationPath: "assets/lottie/expense_tracker.json",
    labelText: "Expense Tracking",
    subLabelText:
        "Simplify your financial life by tracking expenses on the go. Easily categorize transactions, attach receipts, and gain insights into your spending patterns, all in one place.",
  ),
  PageFormat(
    animationPath: "assets/lottie/budget_tracker.json",
    labelText: "Budget Planning",
    subLabelText:
        "Take control of your money with our budget planning tool. Set personalized budgets for different categories, visualize your progress, and make informed spending decisions to meet your financial aspirations.",
  ),
];

class PageFormat extends StatelessWidget {
  final String animationPath;
  final String buttonText;
  final String labelText;
  final String subLabelText;

  const PageFormat({super.key, required this.animationPath, this.buttonText = "Next", required this.labelText, required this.subLabelText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ClipRRect(borderRadius: BorderRadius.circular(30), child: Lottie.asset(animationPath))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
            child: Text(
              labelText,
              textAlign: TextAlign.center,
              style: kwhiteTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: Text(
              subLabelText,
              textAlign: TextAlign.center,
              style: kwhiteTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }
}
