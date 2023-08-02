// ignore_for_file: prefer_const_constructors

import 'package:expenses_tracker/API/database.dart';
import 'package:flutter/material.dart';
import '../Componet/balance_card.dart';
import '../Componet/transaction.dart';
import '../constant.dart';

class ToPayPage extends StatelessWidget {
  static String id = "ToPay page";
  const ToPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    Database db = Database();
    db.getTransactionDB();
    db.getAmountDB();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FAB button pressed
        },
        backgroundColor: kColorExpenses,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: kBackgroundColorAppBar,
        title: Text(
          "All To Pay",
          style: kwhiteboldTextStyle,
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
                    cardName: "TOTAL TO PAY",
                    cardBalanceAmt: db.amountsList[toPayD].toString(),
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
              for (int i = db.TransactionList.length - 1; i >= 0; i--)
                if (db.TransactionList[i][transationNameD] != null &&
                    // ignore: unnecessary_null_comparison
                    db.TransactionList[i][transactionAmountD].toString() != null &&
                    db.TransactionList[i][transactionTypeD] != "0" &&
                    db.TransactionList[i][transactionTagD] != null &&
                    db.TransactionList[i][transactionDateD] != null &&
                    db.TransactionList[i][transactionAccountD] != null &&
                    db.TransactionList[i][transactionPersonD] != null &&
                    db.TransactionList[i][transactionCreatedDateD] != null &&
                    db.TransactionList[i][transactionDescriptionD] != null &&
                    db.TransactionList[i][transactionTypeD] == toPayT)
                  TranactionCard(
                    transationName: db.TransactionList[i][transationNameD],
                    transactionAmount: db.TransactionList[i][transactionAmountD].toString(),
                    transactionType: db.TransactionList[i][transactionTypeD],
                    transactionTag: db.TransactionList[i][transactionTagD],
                    transactionDate: db.TransactionList[i][transactionDateD],
                    transactionAccount: db.TransactionList[i][transactionAccountD],
                    transactionPerson: db.TransactionList[i][transactionPersonD],
                    transactionDescription: db.TransactionList[i][transactionDescriptionD],
                    iconsName: db.TransactionList[i][transactionIconD] == "shooping" ? Icons.shopping_cart_outlined : Icons.abc,
                    transactionCreatedDate: db.TransactionList[i][transactionCreatedDateD] ?? "",
                    // Account: db.TransactionList[i]["account"] ?? "Cash",
                  ),
            ],
          ),
        )),
      ),
    );
  }
}
