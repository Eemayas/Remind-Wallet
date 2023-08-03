// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'package:expenses_tracker/Pages/edit_account.dart';
import 'package:expenses_tracker/Pages/transaction_detail_page.dart';
import 'package:expenses_tracker/Provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../API/database.dart';
import '../constant.dart';

class AccountDetailPage extends StatefulWidget {
  final int index;

  static String id = "accoun detail page";
  const AccountDetailPage({
    super.key,
    required this.index,
  });

  @override
  State<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {
  @override
  Widget build(BuildContext context) {
    Database db = Database();
    db.getAccountDB();
    int index = widget.index;
    // final index = db.AccountsList.indexWhere(
    //     (element) => element[accountNameD] == widget.accountName && element[accountCurrentBalanceD].toString() == widget.amount);
    print(widget.index);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditAccount(accountName: db.AccountsList[index][accountNameD], amount: db.AccountsList[index][accountCurrentBalanceD])));
          db.getAccountDB();
          db.getAmountDB();
          db.getTransactionDB();
          setState(() {
            print("reset");
          });
          // }
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
      ),
      appBar: AppBar(
        backgroundColor: kBackgroundColorAppBar,
        title: Text(
          "Account Detail",
          style: kwhiteboldTextStyle,
        ),
        actions: [
          IconButton(icon: Icon(Icons.account_balance_outlined), onPressed: () => {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              DetailField(
                iconsData: Icons.account_balance_outlined,
                title: 'Title',
                isNote: true,
                data: db.AccountsList[index][accountNameD],
                // data: widget.transactionTitle,
              ),
              DetailField(
                iconsData: Icons.money,
                title: 'Amount',
                data: "RS ${db.AccountsList[index][accountCurrentBalanceD]}",
                // data: "RS ${widget.amount}",
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
