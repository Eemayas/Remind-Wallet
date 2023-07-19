// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:expenses_tracker/Componet/BalanceCard.dart';
import 'package:expenses_tracker/Pages/expensesPage.dart';
import 'package:expenses_tracker/Pages/incomePage.dart';
import 'package:expenses_tracker/Pages/toPayPage.dart';
import 'package:expenses_tracker/Pages/toReceivePage.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:flutter/material.dart';

import '../API/Account.dart';
import '../API/AmountList.dart';
import '../API/TransactionList.dart';

class Dashboard extends StatefulWidget {
  static String id = "DashBoard page";
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FAB button pressed
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: kBackgroundColorAppBar,
        title: Text(
          "Dashboard",
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
              Text("Hi,", style: kwhiteTextStyle.copyWith(fontSize: 20)),
              Text("Prashant Manandhar,",
                  style: kwhiteTextStyle.copyWith(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),

              //Amount Details Section
              Column(
                children: [
                  BalanceCard(
                    cardName: "CURRENT BALANCE",
                    cardBalanceAmt: amountsList["currentBalance"].toString(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Cards(
                        cardName: "TOTAL INCOME",
                        amount: amountsList["totalIncome"].toString(),
                        boxShadowColor: kBoxShadowIncome,
                        color: kBackgroundColorCard,
                        icons: Icon(
                          Icons.arrow_downward,
                          color: kColorIncome,
                        ),
                        nextPage: IncomePage.id,
                        borderColor: Colors
                            .transparent, //Color.fromARGB(168, 105, 240, 175),
                        iconBgColor: Color(0x33008000),
                      ),
                      Cards(
                        cardName: "TOTAL EXPENSES",
                        amount: amountsList["totalExpenses"].toString(),
                        boxShadowColor: kBoxShadowExpenses,
                        color: kBackgroundColorCard,
                        icons: Icon(Icons.arrow_upward, color: kColorExpenses),
                        borderColor: Colors.transparent, //Colors.red,
                        iconBgColor: Color(0x33FF0000),
                        nextPage: ExpensePage.id,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Cards(
                        cardName: "TO RECEIVE",
                        amount: amountsList["toReceive"].toString(),
                        boxShadowColor: kBoxShadowIncome,
                        color: kBackgroundColorCard,
                        icons: Icon(
                          Icons.arrow_downward,
                          color: kColorIncome,
                        ),
                        borderColor: Colors
                            .transparent, //Color.fromARGB(168, 105, 240, 175),
                        iconBgColor: Color(0x33008000),
                        nextPage: ToReceivePage.id,
                      ),
                      Cards(
                        cardName: "TO PAY",
                        amount: amountsList["toPay"].toString(),
                        boxShadowColor: kBoxShadowExpenses,
                        color: kBackgroundColorCard,
                        icons: Icon(Icons.arrow_upward, color: kColorExpenses),
                        borderColor: Colors.transparent, // Colors.red,
                        iconBgColor: Color(0x33FF0000),
                        nextPage: ToPayPage.id,
                      ),
                      // Cards(),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              Text(
                "Accounts",
                style: kwhiteTextStyle.copyWith(fontSize: 20),
              ),

              //Account Section
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < Accounts.length; i++)
                      Row(
                        children: [
                          Accounts[i],
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                  ],
                ),
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

class AccountCard extends StatelessWidget {
  final String cardDetail;
  final String amount;
  final Color color;
  final Icon icons;
  final Color borderColor;
  final Color boxShadowColor;
  final Color iconBgColor;
  final String accountName;

  const AccountCard(
      {super.key,
      required this.cardDetail,
      required this.amount,
      required this.color,
      required this.icons,
      required this.borderColor,
      required this.boxShadowColor,
      required this.iconBgColor,
      required this.accountName});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: borderColor,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: boxShadowColor,
              offset: Offset(6, 6),
              blurRadius: 3,
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        width: 150,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(accountName,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kwhiteTextStyle.copyWith(
                            fontSize: 25, fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("CURRENT BALANCE",
                  style: ksubTextStyle.copyWith(
                      fontSize: 12, fontWeight: FontWeight.w300)),
              SizedBox(
                height: 10,
              ),
              Text('Rs $amount ',
                  style: kwhiteTextStyle.copyWith(
                      fontSize: 25, fontWeight: FontWeight.w300)),
            ],
          ),
        ),
      ),
    );
  }
}

class Cards extends StatelessWidget {
  final String cardName;
  final String amount;
  final Color color;
  final Icon icons;
  final Color borderColor;
  final Color boxShadowColor;
  final Color iconBgColor;
  final String nextPage;

  const Cards(
      {super.key,
      required this.cardName,
      required this.amount,
      required this.color,
      required this.icons,
      required this.borderColor,
      required this.boxShadowColor,
      required this.iconBgColor,
      required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, nextPage),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: borderColor,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                offset: Offset(6, 6),
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(child: icons),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(cardName,
                    style: ksubTextStyle.copyWith(
                        fontSize: 12, fontWeight: FontWeight.w300)),
                SizedBox(
                  height: 10,
                ),
                Text('Rs $amount ',
                    style: kwhiteTextStyle.copyWith(
                        fontSize: 25, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
