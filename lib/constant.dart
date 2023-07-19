import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kBackgroundColor = Color(0xff1E1E1E);
const Color kBackgroundColorAppBar = Color.fromARGB(255, 43, 41, 50);
const Color kBackgroundColorCard = Color.fromARGB(255, 43, 41, 50);

const Color kBoxShadowIncome = Color(0x7F008000);
const Color kBoxShadowExpenses = Color(0x7FFF0000);

const Color kColorExpenses = Color.fromARGB(255, 255, 0, 0);
const Color kColorIncome = Color.fromARGB(255, 0, 250, 9);

const Color kMainBoxBorderColor = Color.fromARGB(168, 105, 240, 175);
const Color kBoxShadowMainBoxBolor = Color.fromARGB(168, 105, 240, 175);

TextStyle kwhiteTextStyle = GoogleFonts.quicksand(
  textStyle:
      const TextStyle(letterSpacing: 1, fontSize: 15, color: Color(0xffF2F2F2)),
);

TextStyle ksubTextStyle = GoogleFonts.quicksand(
  textStyle: const TextStyle(letterSpacing: 1, color: Color(0xffBDBDBD)),
);

const String incomeT = "Income";
const String expensesT = "Expenses";
const String toReceiveT = "to Receive";
const String toPayT = "To Pay";
