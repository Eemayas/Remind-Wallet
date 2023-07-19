// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../API/amount_list.dart';
import '../API/transaction_list.dart';
import '../Componet/balance_card.dart';
import '../Componet/transaction.dart';
import '../constant.dart';

class ToPayPage extends StatelessWidget {
  static String id = "ToPay page";
  const ToPayPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    cardName: "TOTAL TO PAY",
                    cardBalanceAmt: amountsList["toPay"].toString(),
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
              for (int i = 0; i < TransactionList.length; i++)
                if (TransactionList[i]["Category"] == toPayT)
                  TranactionCard(
                    Category: TransactionList[i]["Category"],
                    transationName: TransactionList[i]["transationName"],
                    transactionTag: TransactionList[i]["transactionTag"],
                    transactionDescription: TransactionList[i]
                        ["transactionDescription"],
                    transactionTags: TransactionList[i]["transactionTags"],
                    iconsName: TransactionList[i]["iconsName"],
                  ),
            ],
          ),
        )),
      ),
    );
  }
}
