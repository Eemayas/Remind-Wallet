import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remind_wallet/models/transaction_model.dart';

class TransactionIcon {
  final IconData icon;
  final Color color;
  final TransactionType? type;

  TransactionIcon({
    required this.icon,
    required this.color,
    this.type,
  });
}

final List<TransactionIcon> initialExpenseCategoryIcons = [
  TransactionIcon(
      icon: FontAwesomeIcons.baby,
      color: Colors.brown,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.soap,
      color: Colors.pink,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.fileInvoiceDollar,
      color: Colors.grey,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.car,
      color: Colors.purple,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.shirt,
      color: Colors.orange,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.graduationCap,
      color: Colors.blue,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.tv,
      color: Colors.teal,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.film,
      color: Colors.indigo,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.utensils,
      color: Colors.red,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.heartPulse,
      color: Colors.deepOrange,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.house,
      color: Colors.pinkAccent,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.shieldHalved,
      color: Colors.orangeAccent,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.bagShopping,
      color: Colors.blue,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.peopleGroup,
      color: Colors.green,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.volleyball,
      color: Colors.lightGreen,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.fileInvoice,
      color: Colors.deepOrange,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.phone,
      color: Colors.lime,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.dollarSign,
      color: Colors.blueAccent,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.bus,
      color: Colors.indigo,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.cartShopping,
      color: Colors.indigo,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.moneyBillWave,
      color: Colors.red,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.fileLines,
      color: Colors.blueGrey,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.burger,
      color: Colors.deepOrange,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.gasPump,
      color: Colors.amber.shade800,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.houseChimney,
      color: Colors.brown,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.mobileScreen,
      color: Colors.lightBlue,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.creditCard,
      color: Colors.teal,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.planeDeparture,
      color: Colors.blue,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.briefcaseMedical,
      color: Colors.pinkAccent,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.masksTheater,
      color: Colors.deepPurple,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.graduationCap,
      color: Colors.orange,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.mugHot,
      color: Colors.brown.shade400,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.paw,
      color: Colors.teal.shade300,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.futbol,
      color: Colors.green.shade700,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.hatCowboy,
      color: Colors.purpleAccent,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.wifi,
      color: Colors.indigoAccent,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.lightbulb,
      color: Colors.yellow.shade700,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.laptop,
      color: Colors.grey.shade800,
      type: TransactionType.expense),
  TransactionIcon(
      icon: FontAwesomeIcons.repeat,
      color: Colors.cyan.shade700,
      type: TransactionType.expense),
];

final List<TransactionIcon> initialIncomeCategoryIcons = [
  TransactionIcon(
      icon: FontAwesomeIcons.moneyBill1Wave,
      color: Colors.green,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.coins,
      color: Colors.amber,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.wallet,
      color: Colors.brown,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.chartLine,
      color: Colors.lightGreen,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.arrowRightArrowLeft,
      color: Colors.teal,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.piggyBank,
      color: Colors.blueAccent,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.gift,
      color: Colors.purple,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.moneyCheckDollar,
      color: Colors.indigo,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.gift,
      color: Colors.deepPurple,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.receipt,
      color: Colors.blueGrey,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.moneyBillTrendUp,
      color: Colors.orangeAccent,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.university,
      color: Colors.cyan,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.chartColumn,
      color: Colors.greenAccent,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.bullseye,
      color: Colors.lightBlue,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.paperclip,
      color: Colors.grey,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.trophy,
      color: Colors.amberAccent,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.wallet,
      color: Colors.brown.shade700,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.arrowTrendUp,
      color: Colors.lime,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.fileInvoice,
      color: Colors.blueGrey.shade600,
      type: TransactionType.income),
  TransactionIcon(
      icon: FontAwesomeIcons.noteSticky,
      color: Colors.deepPurpleAccent,
      type: TransactionType.income),
];

final List<TransactionIcon> initialAccountCategoryIcons = [
  TransactionIcon(
    icon: Icons.account_balance, // Bank account
    color: Colors.blue,
  ),
  TransactionIcon(
    icon: Icons.account_circle, // Personal/Checking account
    color: Colors.green,
  ),
  TransactionIcon(
    icon: Icons.savings, // Savings
    color: Colors.purple,
  ),
  TransactionIcon(
    icon: Icons.credit_card, // Credit account
    color: Colors.red,
  ),
  TransactionIcon(
    icon: Icons.show_chart, // Investment account
    color: Colors.orange,
  ),
  TransactionIcon(
    icon: Icons.wallet, // Wallet / digital account
    color: Colors.teal,
  ),
];
