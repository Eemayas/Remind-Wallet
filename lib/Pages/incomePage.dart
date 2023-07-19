// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../API/AmountList.dart';
import '../API/TransactionList.dart';
import '../Componet/BalanceCard.dart';
import '../constant.dart';

class IncomePage extends StatelessWidget {
  static String id = "Income page";
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FAB button pressed
        },
        backgroundColor: kColorIncome,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: kBackgroundColorAppBar,
        title: Text(
          "All Income",
          style: kwhiteTextStyle,
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () => {}),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Amount Details Section
              Column(
                children: [
                  BalanceCard(
                    cardName: "TOTAL INCOME",
                    cardBalanceAmt: amountsList["totalIncome"].toString(),
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              //Recent Transaction Section
              Text(
                "Recent Transactions",
                style: kwhiteTextStyle.copyWith(fontSize: 20),
              ),
              for (int i = 0; i < recentTransactionsLists.length; i++)
                recentTransactionsLists[i]
            ],
          ),
        )),
      ),
    );
  }
}
