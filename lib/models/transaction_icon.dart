import 'package:flutter/material.dart';
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

final List<TransactionIcon> categoryIcons = [
  TransactionIcon(
      icon: Icons.attach_money,
      color: Colors.green,
      type: TransactionType.income), // direct cash
  TransactionIcon(
      icon: Icons.monetization_on,
      color: Colors.amber,
      type: TransactionType.income), // investment
  TransactionIcon(
      icon: Icons.account_balance_wallet,
      color: Colors.brown,
      type: TransactionType.income), // wallet
  TransactionIcon(
      icon: Icons.trending_up,
      color: Colors.lightGreen,
      type: TransactionType.income), // growth
  TransactionIcon(
      icon: Icons.payments,
      color: Colors.teal,
      type: TransactionType.income), // bank transfer
  TransactionIcon(
      icon: Icons.savings,
      color: Colors.blueAccent,
      type: TransactionType.income), // savings account
  TransactionIcon(
      icon: Icons.card_giftcard,
      color: Colors.purple,
      type: TransactionType.income), // gift
  TransactionIcon(
      icon: Icons.paid,
      color: Colors.indigo,
      type: TransactionType.income), // official payment
  TransactionIcon(
      icon: Icons.redeem,
      color: Colors.deepPurple,
      type: TransactionType.income), // redeemed rewards
  TransactionIcon(
      icon: Icons.receipt_long,
      color: Colors.blueGrey,
      type: TransactionType.income), // salary statement
  TransactionIcon(
      icon: Icons.moving,
      color: Colors.orangeAccent,
      type: TransactionType.income), // passive income
  TransactionIcon(
      icon: Icons.account_balance,
      color: Colors.cyan,
      type: TransactionType.income), // institution fund
  TransactionIcon(
      icon: Icons.auto_graph,
      color: Colors.greenAccent,
      type: TransactionType.income), // stock profits
  TransactionIcon(
      icon: Icons.check_circle,
      color: Colors.lightBlue,
      type: TransactionType.income), // completed goals
  TransactionIcon(
      icon: Icons.attach_file,
      color: Colors.grey,
      type: TransactionType.income), // documents
  TransactionIcon(
      icon: Icons.emoji_events,
      color: Colors.amberAccent,
      type: TransactionType.income), // rewards/prizes
  TransactionIcon(
      icon: Icons.wallet,
      color: Colors.brown.shade700,
      type: TransactionType.income), // physical wallet
  TransactionIcon(
      icon: Icons.trending_flat,
      color: Colors.lime,
      type: TransactionType.income), // consistent income
  TransactionIcon(
      icon: Icons.request_page,
      color: Colors.blueGrey.shade600,
      type: TransactionType.income), // invoice
  TransactionIcon(
      icon: Icons.note_add,
      color: Colors.deepPurpleAccent,
      type: TransactionType.income), // record addition

  TransactionIcon(
      icon: Icons.shopping_cart,
      color: Colors.indigo,
      type: TransactionType.expense), // shopping
  TransactionIcon(
      icon: Icons.money_off,
      color: Colors.red,
      type: TransactionType.expense), // loss
  TransactionIcon(
      icon: Icons.receipt,
      color: Colors.blueGrey,
      type: TransactionType.expense), // bill
  TransactionIcon(
      icon: Icons.fastfood,
      color: Colors.deepOrange,
      type: TransactionType.expense), // food
  TransactionIcon(
      icon: Icons.local_gas_station,
      color: Colors.amber.shade800,
      type: TransactionType.expense), // fuel
  TransactionIcon(
      icon: Icons.home,
      color: Colors.brown,
      type: TransactionType.expense), // rent/mortgage
  TransactionIcon(
      icon: Icons.phone_android,
      color: Colors.lightBlue,
      type: TransactionType.expense), // mobile expense
  TransactionIcon(
      icon: Icons.credit_card,
      color: Colors.teal,
      type: TransactionType.expense), // credit card payments
  TransactionIcon(
      icon: Icons.flight_takeoff,
      color: Colors.blue,
      type: TransactionType.expense), // travel
  TransactionIcon(
      icon: Icons.healing,
      color: Colors.pinkAccent,
      type: TransactionType.expense), // medical
  TransactionIcon(
      icon: Icons.theater_comedy,
      color: Colors.deepPurple,
      type: TransactionType.expense), // entertainment
  TransactionIcon(
      icon: Icons.school,
      color: Colors.orange,
      type: TransactionType.expense), // education
  TransactionIcon(
      icon: Icons.coffee,
      color: Colors.brown.shade400,
      type: TransactionType.expense), // coffee/snacks
  TransactionIcon(
      icon: Icons.pets,
      color: Colors.teal.shade300,
      type: TransactionType.expense), // pet care
  TransactionIcon(
      icon: Icons.sports_soccer,
      color: Colors.green.shade700,
      type: TransactionType.expense), // sports
  TransactionIcon(
      icon: Icons.style,
      color: Colors.purpleAccent,
      type: TransactionType.expense), // fashion
  TransactionIcon(
      icon: Icons.wifi,
      color: Colors.indigoAccent,
      type: TransactionType.expense), // internet
  TransactionIcon(
      icon: Icons.lightbulb,
      color: Colors.yellow.shade700,
      type: TransactionType.expense), // electricity
  TransactionIcon(
      icon: Icons.laptop_mac,
      color: Colors.grey.shade800,
      type: TransactionType.expense), // gadgets
  TransactionIcon(
      icon: Icons.subscriptions,
      color: Colors.cyan.shade700,
      type: TransactionType.expense), // recurring bills
];

final List<TransactionIcon> accountIcons = [
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
