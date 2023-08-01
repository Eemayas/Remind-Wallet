// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, avoid_print

import 'package:expenses_tracker/API/database.dart';
import 'package:expenses_tracker/Componet/balance_card.dart';
import 'package:expenses_tracker/Pages/add_account.dart';
import 'package:expenses_tracker/Pages/add_transaction.dart';
import 'package:expenses_tracker/Pages/expenses_page.dart';
import 'package:expenses_tracker/Pages/income_page.dart';
import 'package:expenses_tracker/Pages/to_pay_page.dart';
import 'package:expenses_tracker/Pages/to_receive_page.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../Componet/account_card.dart';
import '../Componet/transaction.dart';
import '../Provider/provider.dart';

class Dashboard extends StatefulWidget {
  static String id = "DashBoard page";
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    db.getTransactionDB();
    db.getAmountDB();
    db.getAccountDB();
    db.getUserNameDB();
    db.getAccountNameListDB();
    // db.deleteUserName();
    // db.deleteAmountDB();
    // db.deleteTransaction();
    // db.deleteAccountDB();
    super.initState();
  }

  Database db = Database();
  var changed = "";
  @override
  Widget build(BuildContext context) {
    if (context.watch<ChangedMsg>().result == "changed") {
      // context.read<ChangedMsg>().unchanged();
      setState(() {});
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // db.updateTransactionDb();
          // db.updateAccountDb();
          // db.updateAmountDb();

          final result = await Navigator.pushNamed(context, AddTransaction.id);
          print(result);
          if (result != null) {
            db.getAccountDB();
            db.getAmountDB();
            db.getTransactionDB();
            setState(() {});
          }
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
          GestureDetector(
              onLongPress: () {
                db.deleteAmountDB();
                db.deleteTransactionDB();
                db.deleteAccountDB();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: kBackgroundColorCard,
                      content: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Database Deleted',
                            style: kwhiteTextStyle,
                          ),
                        ],
                      )),
                );
                db.getAccountDB();
                db.getAmountDB();
                db.getTransactionDB();
                setState(() {});
              },
              onDoubleTap: () {
                db.getAccountDB();
                db.getAmountDB();
                db.getTransactionDB();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: kBackgroundColorCard,
                      content: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Database Refresh',
                            style: kwhiteTextStyle,
                          ),
                        ],
                      )),
                );
              },
              child: Icon(Icons.more_vert)),
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
              Text("${db.userDetail[userNameD]},", style: kwhiteTextStyle.copyWith(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),

              //? Amount Details Section
              Column(
                children: [
                  BalanceCard(
                    cardName: "CURRENT BALANCE",
                    cardBalanceAmt: db.amountsList["currentBalance"].toString(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Cards(
                        cardName: "TOTAL INCOME",
                        amount: db.amountsList["totalIncome"].toString(),
                        boxShadowColor: kBoxShadowIncome,
                        color: kBackgroundColorCard,
                        icons: Icon(
                          Icons.arrow_downward,
                          color: kColorIncome,
                        ),
                        nextPage: IncomePage.id,
                        borderColor: Colors.transparent, //Color.fromARGB(168, 105, 240, 175),
                        iconBgColor: Color(0x33008000),
                      ),
                      Cards(
                        cardName: "TOTAL EXPENSES",
                        amount: db.amountsList["totalExpenses"].toString(),
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
                        amount: db.amountsList["toReceive"].toString(),
                        boxShadowColor: kBoxShadowIncome,
                        color: kBackgroundColorCard,
                        icons: Icon(
                          Icons.arrow_downward,
                          color: kColorIncome,
                        ),
                        borderColor: Colors.transparent, //Color.fromARGB(168, 105, 240, 175),
                        iconBgColor: Color(0x33008000),
                        nextPage: ToReceivePage.id,
                      ),
                      Cards(
                        cardName: "TO PAY",
                        amount: db.amountsList["toPay"].toString(),
                        boxShadowColor: kBoxShadowExpenses,
                        color: kBackgroundColorCard,
                        icons: Icon(Icons.arrow_upward, color: kColorExpenses),
                        borderColor: Colors.transparent, // Colors.red,
                        iconBgColor: Color(0x33FF0000),
                        nextPage: ToPayPage.id,
                      ),
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

              //* Account Section
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < db.AccountsList.length; i++)
                      Row(
                        children: [
                          AccountCard(
                            accountName: db.AccountsList[i][accountNameD],
                            amount: db.AccountsList[i][accountCurrentBalanceD].toString(),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.pushNamed(context, AddAccount.id);
                        print(result);
                        if (result != null) {
                          db.getAccountDB();
                          db.getAmountDB();
                          db.getTransactionDB();
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kMainBoxBorderColor,
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kBoxShadowMainBoxBolor,
                              offset: Offset(6, 6),
                              blurRadius: 3,
                            ),
                          ],
                          color: kBackgroundColorCard,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),

              //* Recent Transaction Section
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
                    db.TransactionList[i][transactionDescriptionD] != null)
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
                Text(cardName, style: ksubTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w300)),
                SizedBox(
                  height: 10,
                ),
                Text('Rs $amount ', style: kwhiteTextStyle.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
