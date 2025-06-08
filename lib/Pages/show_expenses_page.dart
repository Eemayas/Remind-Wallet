// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../API/database.dart';
import '../Componet/balance_card.dart';
import '../Componet/transaction.dart';
import '../constant.dart';

class ExpensePage extends StatelessWidget {
  static String id = "Expense page";
  const ExpensePage({super.key});

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
          "All Expenses",
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
                    cardName: "TOTAL EXPENSES",
                    cardBalanceAmt: Database.amountsList[totalExpensesD].toString(),
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
              for (int i = Database.TransactionList.length - 1; i >= 0; i--)
                if (Database.TransactionList[i][transationNameD] != null &&
                    // ignore: unnecessary_null_comparison
                    Database.TransactionList[i][transactionAmountD].toString() != null &&
                    Database.TransactionList[i][transactionTypeD] != null &&
                    Database.TransactionList[i][transactionTagD] != null &&
                    Database.TransactionList[i][transactionDateD] != null &&
                    Database.TransactionList[i][transactionAccountD] != null &&
                    Database.TransactionList[i][transactionPersonD] != null &&
                    Database.TransactionList[i][transactionCreatedDateD] != null &&
                    Database.TransactionList[i][transactionDescriptionD] != null &&
                    Database.TransactionList[i][transactionTypeD] == expensesT)
                  TranactionCard(
                    transationName: Database.TransactionList[i][transationNameD],
                    transactionAmount: Database.TransactionList[i][transactionAmountD].toString(),
                    transactionType: Database.TransactionList[i][transactionTypeD],
                    transactionTag: Database.TransactionList[i][transactionTagD],
                    transactionDate: Database.TransactionList[i][transactionDateD],
                    transactionAccount: Database.TransactionList[i][transactionAccountD],
                    transactionPerson: Database.TransactionList[i][transactionPersonD],
                    transactionDescription: Database.TransactionList[i][transactionDescriptionD],
                    iconsName: getIconForElement(Database.TransactionList[i][transactionTagD]),
                    // iconsName: db.TransactionList[i][transactionIconD] == "shooping" ? Icons.shopping_cart_outlined : Icons.abc,
                    transactionCreatedDate: Database.TransactionList[i][transactionCreatedDateD] ?? "",
                    // Account: db.TransactionList[i]["account"] ?? "Cash",
                  ),
            ],
          ),
        )),
      ),
    );
  }
}
