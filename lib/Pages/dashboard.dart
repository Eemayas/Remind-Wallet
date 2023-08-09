// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:expenses_tracker/API/database.dart';
import 'package:expenses_tracker/API/firebase_databse.dart';
import 'package:expenses_tracker/Componet/balance_card.dart';
import 'package:expenses_tracker/Componet/custom_alert_dialog.dart';
import 'package:expenses_tracker/Componet/custom_drawer.dart';
import 'package:expenses_tracker/Componet/custom_snackbar.dart';
import 'package:expenses_tracker/Pages/add_account.dart';
import 'package:expenses_tracker/Pages/add_transaction.dart';
import 'package:expenses_tracker/Pages/show_expenses_page.dart';
import 'package:expenses_tracker/Pages/show_to_pay_page.dart';
import 'package:expenses_tracker/Pages/show_income_page.dart';
import 'package:expenses_tracker/Pages/show_to_receive_page.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    // EasyLoading.show(dismissOnTap: true);
    db.getTransactionDB();
    db.getAmountDB();
    db.getAccountDB();
    db.getUserDetailDB();
    db.getAccountNameListDB();
    // db.deleteUserName();
    // db.deleteAmountDB();
    // db.deleteTransaction();
    // db.deleteAccountDB();
    super.initState();
  }

  Database db = Database();
  FirebaseDatabases fd = FirebaseDatabases();
  var changed = "";
  @override
  Widget build(BuildContext context) {
    Future<void> _handleMenuItemClick(String value, BuildContext context) async {
      // Implement the logic for each option here
      switch (value) {
        case 'Delete DataBase':
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                    title: 'Warning: Database Deletion',
                    titleTextColor: Colors.red,
                    confirmTextColor: Colors.red,
                    message: 'Are you sure you want to delete the database? This action cannot be undone.',
                    onConfirm: () {
                      EasyLoading.show(status: 'Deleting database', maskType: EasyLoadingMaskType.black, dismissOnTap: true);
                      db.deleteAll();
                      Navigator.pop(context);
                      customSnackbar(
                        context: context,
                        text: 'Database Deleted',
                        icons: Icons.delete_forever,
                      );
                      db.getAccountDB();
                      db.getAmountDB();
                      db.getTransactionDB();
                      EasyLoading.dismiss();
                      setState(() {});
                    });
              });
          break;
        case 'Update DataBase':
          EasyLoading.show(
            status: 'Updating database',
            maskType: EasyLoadingMaskType.black,
          );
          db.getAccountDB();
          db.getAmountDB();
          db.getTransactionDB();
          EasyLoading.dismiss();
          setState(() {});
          customSnackbar(context: context, text: 'Database Refresh', icons: Icons.done_all, iconsColor: Colors.green);
          break;
        case 'Options:':
          break;
        case 'Upload to cloud':
          // ignore: unused_local_variable
          EasyLoading.show(
            status: 'Uploading to cloud',
            maskType: EasyLoadingMaskType.black,
          );
          Future<bool> isSucess = fd.saveAllDataToFirebase(context);
          if (await isSucess) {
            EasyLoading.dismiss();
          }
          {
            EasyLoading.dismiss();
          }
          break;
        case 'Retrive from cloud':
          EasyLoading.show(
            status: 'Retriving from cloud',
            maskType: EasyLoadingMaskType.black,
          );
          // ignore: unused_local_variable
          Future<bool> isSucess = fd.retrieveAllDataFromFirebase(context);
          if (await isSucess) {
            customSnackbar(context: context, text: "All datas are received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
            db.getAccountDB();
            db.getAmountDB();
            db.getTransactionDB();
            EasyLoading.dismiss();
            setState(() {});
          } else {
            EasyLoading.dismiss();
          }

          break;
        case 'Logout':
          EasyLoading.show(
            status: 'Processing',
            maskType: EasyLoadingMaskType.black,
          );
          // Future<bool> isSucess = fd.saveAllDataToFirebase(context);
          if (await fd.saveAllDataToFirebase(context)) {
            db.deleteAll();
            db.deleteUserDetailDB();
            await FirebaseAuth.instance.signOut();
            EasyLoading.dismiss();
            customSnackbar(context: context, text: 'Logout Sucessfully', icons: Icons.logout_rounded, iconsColor: Colors.green);
          } else {
            EasyLoading.dismiss();
            customSnackbar(
              context: context,
              text: 'Please Upload to Firebase First',
            );
          }
          break;
      }
    }

    if (context.watch<ChangedMsg>().result == "changed") {
      db.getAccountDB();
      db.getAmountDB();
      db.getTransactionDB();
      setState(() {});
    }

    return Scaffold(
      drawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
          style: kwhiteboldTextStyle,
        ),
        actions: [
          popupItems(_handleMenuItemClick, context),
          // GestureDetector(
          //     onLongPress: () {
          //       db.deleteAmountDB();
          //       db.deleteTransactionDB();
          //       db.deleteAccountDB();
          //       customSnackbar(context: context, text: 'Database Deleted');
          //       db.getAccountDB();
          //       db.getAmountDB();
          //       db.getTransactionDB();
          //       setState(() {});
          //     },
          //     onDoubleTap: () {
          //       db.getAccountDB();
          //       db.getAmountDB();
          //       db.getTransactionDB();
          //       setState(() {});
          //       customSnackbar(context: context, text: 'Database Refresh', icons: Icons.done_all, iconsColor: Colors.green);
          //     },
          //     child: Icon(Icons.more_vert)),
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
                    transactionAccount: db.TransactionList[i][transactionAccountD].toString(),
                    transactionPerson: db.TransactionList[i][transactionPersonD],
                    transactionDescription: db.TransactionList[i][transactionDescriptionD],
                    iconsName: getIconForElement(db.TransactionList[i][transactionTagD]),
                    // iconsName: db.TransactionList[i][transactionIconD] == "shooping" ? Icons.shopping_cart_outlined : Icons.abc,
                    transactionCreatedDate: db.TransactionList[i][transactionCreatedDateD] ?? "",
                    // Account: db.TransactionList[i]["account"] ?? "Cash",
                  ),
            ],
          ),
        )),
      ),
    );
  }

  Padding popupItems(Future<void> Function(String value, BuildContext context) _handleMenuItemClick, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 20.0,
      ),
      child: PopupMenuButton(
        onSelected: (value) {
          _handleMenuItemClick(value, context);
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            textStyle: kwhiteTextStyle.copyWith(fontWeight: FontWeight.bold),
            value: 'Options:',
            child: Row(
              children: [
                Text('Options:'),
              ],
            ),
          ),
          PopupMenuItem(
            textStyle: kwhiteTextStyle,
            value: 'Upload to cloud',
            child: Row(
              children: [
                Icon(Icons.cloud_done_outlined),
                SizedBox(
                  width: 5,
                ),
                Text('Upload to cloud'),
              ],
            ),
          ),
          PopupMenuItem(
            textStyle: kwhiteTextStyle,
            value: 'Retrive from cloud',
            child: Row(
              children: [
                Icon(Icons.downloading_sharp),
                SizedBox(
                  width: 5,
                ),
                Text('Retrive from cloud'),
              ],
            ),
          ),
          PopupMenuItem(
            textStyle: kwhiteTextStyle,
            value: 'Update DataBase',
            child: Row(
              children: [
                Icon(Icons.update),
                SizedBox(
                  width: 5,
                ),
                Text('Update DataBase'),
              ],
            ),
          ),
          PopupMenuItem(
            textStyle: kwhiteTextStyle,
            value: 'Delete DataBase',
            child: Row(
              children: [
                Icon(Icons.delete_forever_outlined),
                SizedBox(
                  width: 5,
                ),
                Text('Delete DataBase'),
              ],
            ),
          ),
          PopupMenuItem(
            textStyle: kwhiteTextStyle,
            value: 'Logout',
            child: Row(
              children: [
                Icon(Icons.logout_outlined),
                SizedBox(
                  width: 5,
                ),
                Text('Logout'),
              ],
            ),
          ),
        ],
        child: Icon(Icons.more_vert),
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
