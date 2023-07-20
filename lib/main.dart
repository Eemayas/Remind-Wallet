// ignore_for_file: prefer_const_constructors

import 'package:expenses_tracker/Pages/add_account.dart';
import 'package:expenses_tracker/Pages/add_transaction.dart';
import 'package:expenses_tracker/Pages/expenses_page.dart';
import 'package:expenses_tracker/Pages/income_page.dart';
import 'package:expenses_tracker/Pages/to_pay_page.dart';
import 'package:expenses_tracker/Pages/to_receive_page.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:expenses_tracker/Pages/dashboard.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  //* initialize hive
  await Hive.initFlutter();

  //open the box
  var box = await Hive.openBox("expenses_tracker");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
            ),
          )),
      initialRoute: Dashboard.id,
      //TranasctionDetailPage.id, // //AddTransaction.id,
      routes: {
        Dashboard.id: (context) => const Dashboard(),
        IncomePage.id: (context) => const IncomePage(),
        ExpensePage.id: (context) => const ExpensePage(),
        ToPayPage.id: (context) => const ToPayPage(),
        ToReceivePage.id: (context) => const ToReceivePage(),
        AddTransaction.id: (context) => AddTransaction(),
        AddAccount.id: (context) => AddAccount(),
        // EditTransaction.id: (context) => EditTransaction(),
        // TranasctionDetailPage.id: (context) => TranasctionDetailPage(),
      },
      // home: const dashBoard()
    );
  }
}
