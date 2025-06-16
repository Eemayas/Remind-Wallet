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

  TransactionIcon copyWith({
    IconData? icon,
    Color? color,
    TransactionType? type,
  }) {
    return TransactionIcon(
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
    );
  }

  static int getExpenseCategoryIconIndex(TransactionIcon icon) {
    return initialExpenseCategoryIcons
        .indexWhere((e) => e.icon == icon.icon && e.type == icon.type);
  }

  static int getIncomeCategoryIconIndex(TransactionIcon icon) {
    return initialIncomeCategoryIcons
        .indexWhere((e) => e.icon == icon.icon && e.type == icon.type);
  }

  static int getTransferCategoryIconIndex(TransactionIcon icon) {
    return initialTransferCategoryIcons
        .indexWhere((e) => e.icon == icon.icon && e.type == icon.type);
  }

  static int getAccountCategoryIconIndex(TransactionIcon icon) {
    return initialAccountCategoryIcons.indexOf(icon);
  }
}

final List<TransactionIcon> initialTransferCategoryIcons = [
  TransactionIcon(
    icon: FontAwesomeIcons.moneyBillTransfer,
    color: Colors.green,
    type: TransactionType.transfer,
  ),
];

final List<TransactionIcon> initialExpenseCategoryIcons = [
  // 0
  TransactionIcon(
    icon: FontAwesomeIcons.baby,
    color: Colors.brown,
    type: TransactionType.expense,
  ),
  // 1
  TransactionIcon(
    icon: FontAwesomeIcons.soap,
    color: Colors.pink,
    type: TransactionType.expense,
  ),
  // 2
  TransactionIcon(
    icon: FontAwesomeIcons.fileInvoiceDollar,
    color: Colors.grey,
    type: TransactionType.expense,
  ),
  // 3
  TransactionIcon(
    icon: FontAwesomeIcons.car,
    color: Colors.purple,
    type: TransactionType.expense,
  ),
  // 4
  TransactionIcon(
    icon: FontAwesomeIcons.shirt,
    color: Colors.orange,
    type: TransactionType.expense,
  ),
  // 5
  TransactionIcon(
    icon: FontAwesomeIcons.graduationCap,
    color: Colors.blue,
    type: TransactionType.expense,
  ),
  // 6
  TransactionIcon(
    icon: FontAwesomeIcons.tv,
    color: Colors.teal,
    type: TransactionType.expense,
  ),
  // 7
  TransactionIcon(
    icon: FontAwesomeIcons.film,
    color: Colors.indigo,
    type: TransactionType.expense,
  ),
  // 8
  TransactionIcon(
    icon: FontAwesomeIcons.utensils,
    color: Colors.red,
    type: TransactionType.expense,
  ),
  // 9
  TransactionIcon(
    icon: FontAwesomeIcons.heartPulse,
    color: Colors.deepOrange,
    type: TransactionType.expense,
  ),
  // 10
  TransactionIcon(
    icon: FontAwesomeIcons.house,
    color: Colors.pinkAccent,
    type: TransactionType.expense,
  ),
  // 11
  TransactionIcon(
    icon: FontAwesomeIcons.shieldHalved,
    color: Colors.orangeAccent,
    type: TransactionType.expense,
  ),
  // 12
  TransactionIcon(
    icon: FontAwesomeIcons.bagShopping,
    color: Colors.blue,
    type: TransactionType.expense,
  ),
  // 13
  TransactionIcon(
    icon: FontAwesomeIcons.peopleGroup,
    color: Colors.green,
    type: TransactionType.expense,
  ),
  // 14
  TransactionIcon(
    icon: FontAwesomeIcons.volleyball,
    color: Colors.lightGreen,
    type: TransactionType.expense,
  ),
  // 15
  TransactionIcon(
    icon: FontAwesomeIcons.fileInvoice,
    color: Colors.deepOrange,
    type: TransactionType.expense,
  ),
  // 16
  TransactionIcon(
    icon: FontAwesomeIcons.phone,
    color: Colors.lime,
    type: TransactionType.expense,
  ),
  // 17
  TransactionIcon(
    icon: FontAwesomeIcons.bus,
    color: Colors.indigo,
    type: TransactionType.expense,
  ),
  // 18
  TransactionIcon(
    icon: FontAwesomeIcons.cartShopping,
    color: Colors.indigo,
    type: TransactionType.expense,
  ),
  // 19
  TransactionIcon(
    icon: FontAwesomeIcons.moneyBillWave,
    color: Colors.red,
    type: TransactionType.expense,
  ),
  // 20
  TransactionIcon(
    icon: FontAwesomeIcons.fileLines,
    color: Colors.blueGrey,
    type: TransactionType.expense,
  ),
  // 21
  TransactionIcon(
    icon: FontAwesomeIcons.burger,
    color: Colors.deepOrange,
    type: TransactionType.expense,
  ),
  // 22
  TransactionIcon(
    icon: FontAwesomeIcons.gasPump,
    color: Colors.amber.shade800,
    type: TransactionType.expense,
  ),
  // 23
  TransactionIcon(
    icon: FontAwesomeIcons.houseChimney,
    color: Colors.brown,
    type: TransactionType.expense,
  ),
  // 24
  TransactionIcon(
    icon: FontAwesomeIcons.mobileScreen,
    color: Colors.lightBlue,
    type: TransactionType.expense,
  ),
  // 25
  TransactionIcon(
    icon: FontAwesomeIcons.creditCard,
    color: Colors.teal,
    type: TransactionType.expense,
  ),
  // 26
  TransactionIcon(
    icon: FontAwesomeIcons.planeDeparture,
    color: Colors.blue,
    type: TransactionType.expense,
  ),
  // 27
  TransactionIcon(
    icon: FontAwesomeIcons.briefcaseMedical,
    color: Colors.pinkAccent,
    type: TransactionType.expense,
  ),
  // 28
  TransactionIcon(
    icon: FontAwesomeIcons.masksTheater,
    color: Colors.deepPurple,
    type: TransactionType.expense,
  ),
  // 29
  TransactionIcon(
    icon: FontAwesomeIcons.graduationCap,
    color: Colors.orange,
    type: TransactionType.expense,
  ),
  // 30
  TransactionIcon(
    icon: FontAwesomeIcons.mugHot,
    color: Colors.brown.shade400,
    type: TransactionType.expense,
  ),
  // 31
  TransactionIcon(
    icon: FontAwesomeIcons.paw,
    color: Colors.teal.shade300,
    type: TransactionType.expense,
  ),
  // 32
  TransactionIcon(
    icon: FontAwesomeIcons.futbol,
    color: Colors.green.shade700,
    type: TransactionType.expense,
  ),
  // 33
  TransactionIcon(
    icon: FontAwesomeIcons.hatCowboy,
    color: Colors.purpleAccent,
    type: TransactionType.expense,
  ),
  // 34
  TransactionIcon(
    icon: FontAwesomeIcons.wifi,
    color: Colors.indigoAccent,
    type: TransactionType.expense,
  ),
  // 35
  TransactionIcon(
    icon: FontAwesomeIcons.lightbulb,
    color: Colors.yellow.shade700,
    type: TransactionType.expense,
  ),
  // 36
  TransactionIcon(
    icon: FontAwesomeIcons.laptop,
    color: Colors.grey.shade800,
    type: TransactionType.expense,
  ),
  // 37
  TransactionIcon(
    icon: FontAwesomeIcons.repeat,
    color: Colors.cyan.shade700,
    type: TransactionType.expense,
  ),
  // 38
  TransactionIcon(
    icon: FontAwesomeIcons.school,
    color: Colors.blue,
    type: TransactionType.expense,
  ),
  // 39
  TransactionIcon(
    icon: FontAwesomeIcons.cartShopping,
    color: Colors.pink,
    type: TransactionType.expense,
  ),
  //40
  TransactionIcon(
    icon: FontAwesomeIcons.passport,
    color: Colors.indigo,
    type: TransactionType.expense,
  ),
];

final List<TransactionIcon> initialIncomeCategoryIcons = [
  // 0
  TransactionIcon(
    icon: FontAwesomeIcons.moneyBill1Wave,
    color: Colors.green,
    type: TransactionType.income,
  ),
  // 1
  TransactionIcon(
    icon: FontAwesomeIcons.coins,
    color: Colors.amber,
    type: TransactionType.income,
  ),
  // 2
  TransactionIcon(
    icon: FontAwesomeIcons.wallet,
    color: Colors.brown,
    type: TransactionType.income,
  ),
  // 3
  TransactionIcon(
    icon: FontAwesomeIcons.chartLine,
    color: Colors.lightGreen,
    type: TransactionType.income,
  ),
  // 4
  TransactionIcon(
    icon: FontAwesomeIcons.arrowRightArrowLeft,
    color: Colors.teal,
    type: TransactionType.income,
  ),
  // 5
  TransactionIcon(
    icon: FontAwesomeIcons.piggyBank,
    color: Colors.blueAccent,
    type: TransactionType.income,
  ),
  // 6
  TransactionIcon(
    icon: FontAwesomeIcons.gift,
    color: Colors.purple,
    type: TransactionType.income,
  ),
  // 7
  TransactionIcon(
    icon: FontAwesomeIcons.moneyCheckDollar,
    color: Colors.indigo,
    type: TransactionType.income,
  ),
  // 8
  TransactionIcon(
    icon: FontAwesomeIcons.gift,
    color: Colors.deepPurple,
    type: TransactionType.income,
  ),
  // 9
  TransactionIcon(
    icon: FontAwesomeIcons.receipt,
    color: Colors.blueGrey,
    type: TransactionType.income,
  ),
  // 10
  TransactionIcon(
    icon: FontAwesomeIcons.moneyBillTrendUp,
    color: Colors.orangeAccent,
    type: TransactionType.income,
  ),
  // 11
  TransactionIcon(
    icon: FontAwesomeIcons.buildingColumns,
    color: Colors.cyan,
    type: TransactionType.income,
  ),
  // 12
  TransactionIcon(
    icon: FontAwesomeIcons.chartColumn,
    color: Colors.greenAccent,
    type: TransactionType.income,
  ),
  // 13
  TransactionIcon(
    icon: FontAwesomeIcons.bullseye,
    color: Colors.lightBlue,
    type: TransactionType.income,
  ),
  // 14
  TransactionIcon(
    icon: FontAwesomeIcons.paperclip,
    color: Colors.grey,
    type: TransactionType.income,
  ),
  // 15
  TransactionIcon(
    icon: FontAwesomeIcons.trophy,
    color: Colors.amberAccent,
    type: TransactionType.income,
  ),
  // 16
  TransactionIcon(
    icon: FontAwesomeIcons.wallet,
    color: Colors.brown.shade700,
    type: TransactionType.income,
  ),
  // 17
  TransactionIcon(
    icon: FontAwesomeIcons.arrowTrendUp,
    color: Colors.lime,
    type: TransactionType.income,
  ),
  // 18
  TransactionIcon(
    icon: FontAwesomeIcons.fileInvoice,
    color: Colors.blueGrey.shade600,
    type: TransactionType.income,
  ),
  // 19
  TransactionIcon(
    icon: FontAwesomeIcons.noteSticky,
    color: Colors.deepPurpleAccent,
    type: TransactionType.income,
  ),
  // 20
  TransactionIcon(
    icon: FontAwesomeIcons.dollarSign,
    color: Colors.blueAccent,
    type: TransactionType.income,
  ),
  //21
  TransactionIcon(
    icon: FontAwesomeIcons.briefcase,
    color: Colors.purple,
    type: TransactionType.income,
  ),
  // 22
  TransactionIcon(
    icon: FontAwesomeIcons.award,
    color: Colors.amber,
    type: TransactionType.income,
  ),
  // 23
  TransactionIcon(
    icon: FontAwesomeIcons.moneyBillTrendUp,
    color: Colors.green,
    type: TransactionType.income,
  ),
  // 24
  TransactionIcon(
    icon: FontAwesomeIcons.businessTime,
    color: Colors.purple,
    type: TransactionType.income,
  ),
  // 25
  TransactionIcon(
    icon: FontAwesomeIcons.moneyBills,
    color: Colors.lightGreen,
    type: TransactionType.income,
  ),
  // 26
  TransactionIcon(
    icon: FontAwesomeIcons.houseLaptop,
    color: Colors.blueGrey,
    type: TransactionType.income,
  ),
  // 27
  TransactionIcon(
    icon: FontAwesomeIcons.building,
    color: Colors.teal,
    type: TransactionType.income,
  ),
  // 28
  TransactionIcon(
    icon: FontAwesomeIcons.percent,
    color: Colors.orangeAccent,
    type: TransactionType.income,
  ),
  // 29
  TransactionIcon(
    icon: FontAwesomeIcons.arrowRotateLeft,
    color: Colors.blueAccent,
    type: TransactionType.income,
  ),
  // 30
  TransactionIcon(
    icon: FontAwesomeIcons.ticket,
    color: Colors.deepOrange,
    type: TransactionType.income,
  ),
// 31
  TransactionIcon(
    icon: FontAwesomeIcons.coins,
    color: Colors.greenAccent,
    type: TransactionType.income,
  ),
// 32
  TransactionIcon(
    icon: FontAwesomeIcons.toolbox,
    color: Colors.brown,
    type: TransactionType.income,
  ),

  // 33
  TransactionIcon(
    icon: FontAwesomeIcons.handHoldingDollar,
    color: Colors.indigo,
    type: TransactionType.income,
  ),
  // 34
  TransactionIcon(
    icon: FontAwesomeIcons.laptopCode,
    color: Colors.lime,
    type: TransactionType.income,
  ),
  // 35
  TransactionIcon(
    icon: FontAwesomeIcons.youtube,
    color: Colors.redAccent,
    type: TransactionType.income,
  ),
  // 36
  TransactionIcon(
    icon: FontAwesomeIcons.copyright,
    color: Colors.grey,
    type: TransactionType.income,
  ),
  // 37
  TransactionIcon(
    icon: FontAwesomeIcons.houseChimney,
    color: Colors.deepOrangeAccent,
    type: TransactionType.income,
  ),
  // 38
  TransactionIcon(
    icon: FontAwesomeIcons.link,
    color: Colors.purpleAccent,
    type: TransactionType.income,
  ),
  // 39
  TransactionIcon(
    icon: FontAwesomeIcons.cartShopping,
    color: Colors.tealAccent,
    type: TransactionType.income,
  ),
  // 40
  TransactionIcon(
    icon: FontAwesomeIcons.peopleGroup,
    color: Colors.lightBlue,
    type: TransactionType.income,
  ),
  // 41
  TransactionIcon(
    icon: FontAwesomeIcons.store,
    color: Colors.deepPurpleAccent,
    type: TransactionType.income,
  ),
  // 42
  TransactionIcon(
    icon: FontAwesomeIcons.userTie,
    color: Colors.cyanAccent,
    type: TransactionType.income,
  ),
  // 43
  TransactionIcon(
    icon: FontAwesomeIcons.receipt,
    color: Colors.limeAccent,
    type: TransactionType.income,
  ),
  // 44
  TransactionIcon(
    icon: FontAwesomeIcons.handshakeAngle,
    color: Colors.orange,
    type: TransactionType.income,
  ),
  // 45
  TransactionIcon(
    icon: FontAwesomeIcons.bitcoin,
    color: Colors.amberAccent,
    type: TransactionType.income,
  ),
  // 46
  TransactionIcon(
    icon: FontAwesomeIcons.chartPie,
    color: Colors.greenAccent,
    type: TransactionType.income,
  ),
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
