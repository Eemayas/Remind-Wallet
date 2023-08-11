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
import 'package:shared_preferences/shared_preferences.dart';

import '../../Componet/account_card.dart';
import '../../Componet/transaction.dart';
import '../../Provider/provider.dart';
import '../starting_pages/check_page.dart';

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
    db.getUserDetailDB();
    db.getAccountNameListDB();
    // checkLogInStatus();
    super.initState();
  }

  Future<void> checkLogInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogIn') ?? false;
    if (isLogin) {
      EasyLoading.show(
        status: 'Updating database',
        maskType: EasyLoadingMaskType.black,
      );
      if (await fd.retrieveAllDataFromFirebase(context)) {
        setState(() {});
      }
      EasyLoading.dismiss();
      prefs.setBool('isLogIn', false);
      EasyLoading.dismiss();
    }
  }

  Database db = Database();
  FirebaseDatabases fd = FirebaseDatabases();
  var changed = "";
  @override
  Widget build(BuildContext context) {
    checkLogInStatus();
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
                    message: 'Are you sure you want to delete the database? This action cannot be undone.\n You can Upload to cloud before deleting.',
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
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                    title: 'Upload to Cloud',
                    titleTextColor: Colors.white,
                    confirmTextColor: Colors.white,
                    message: 'Are you confident in your decision to proceed with the cloud upload?',
                    onConfirm: () async {
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
                      Navigator.pop(context);
                    });
              });

          break;
        case 'Retrive from cloud':
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                    title: 'Warning: Data Misplaced',
                    titleTextColor: Colors.red,
                    confirmTextColor: Colors.red,
                    message:
                        "Before proceeding, please ensure the security of the data in both the cloud and local storage. To accomplish this, initiate the cloud upload first and then return to this page sequentially. Please note that in the absence of proper data safety measures, recovery may not be feasible.",
                    onConfirm: () async {
                      EasyLoading.show(
                        status: 'Retriving from cloud',
                        maskType: EasyLoadingMaskType.black,
                      );
                      // ignore: unused_local_variable
                      Future<bool> isSucess = fd.retrieveAllDataFromFirebase(context);
                      if (await isSucess) {
                        customSnackbar(
                            context: context, text: "All datas are received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
                        db.getAccountDB();
                        db.getAmountDB();
                        db.getTransactionDB();
                        db.getUserDetailDB();
                        EasyLoading.dismiss();
                        setState(() {});
                      } else {
                        EasyLoading.dismiss();
                      }
                      Navigator.pop(context);
                    });
              });

          break;
        case 'Logout':
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                    title: 'LogOut?',
                    titleTextColor: Colors.red,
                    confirmTextColor: Colors.red,
                    confirmText: "Log out",
                    message: 'Are you certain about proceeding with the logout?',
                    onConfirm: () async {
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
                        Navigator.pop(context);
                        customSnackbar(context: context, text: 'Logout Sucessfully', icons: Icons.logout_rounded, iconsColor: Colors.green);
                      } else {
                        Navigator.pushReplacementNamed(context, CheckSignin_outPage.id);
                        EasyLoading.dismiss();
                        customSnackbar(
                          context: context,
                          text: 'Please Upload to Firebase First',
                        );
                      }
                    });
              });

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
              Text("${Database.userDetail[userNameD]},", style: kwhiteTextStyle.copyWith(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),

              //? Amount Details Section
              Column(
                children: [
                  BalanceCard(
                    cardName: "CURRENT BALANCE",
                    cardBalanceAmt: Database.amountsList["currentBalance"].toString(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Cards(
                        cardName: "TOTAL INCOME",
                        amount: Database.amountsList["totalIncome"].toString(),
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
                        amount: Database.amountsList["totalExpenses"].toString(),
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
                        amount: Database.amountsList["toReceive"].toString(),
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
                        amount: Database.amountsList["toPay"].toString(),
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
                    for (int i = 0; i < Database.AccountsList.length; i++)
                      Row(
                        children: [
                          AccountCard(
                            accountName: Database.AccountsList[i][accountNameD],
                            amount: Database.AccountsList[i][accountCurrentBalanceD].toString(),
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
              for (int i = Database.TransactionList.length - 1; i >= 0; i--)
                if (Database.TransactionList[i][transationNameD] != null &&
                    // ignore: unnecessary_null_comparison
                    Database.TransactionList[i][transactionAmountD].toString() != null &&
                    Database.TransactionList[i][transactionTypeD] != "0" &&
                    Database.TransactionList[i][transactionTagD] != null &&
                    Database.TransactionList[i][transactionDateD] != null &&
                    Database.TransactionList[i][transactionAccountD] != null &&
                    Database.TransactionList[i][transactionPersonD] != null &&
                    Database.TransactionList[i][transactionCreatedDateD] != null &&
                    Database.TransactionList[i][transactionDescriptionD] != null)
                  TranactionCard(
                    transationName: Database.TransactionList[i][transationNameD],
                    transactionAmount: Database.TransactionList[i][transactionAmountD].toString(),
                    transactionType: Database.TransactionList[i][transactionTypeD],
                    transactionTag: Database.TransactionList[i][transactionTagD],
                    transactionDate: Database.TransactionList[i][transactionDateD],
                    transactionAccount: Database.TransactionList[i][transactionAccountD].toString(),
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
