// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print
import 'package:expenses_tracker/API/database.dart';
import 'package:expenses_tracker/Pages/edit_transaction.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:flutter/material.dart';

class TranasctionDetailPage extends StatefulWidget {
  final String transactionTitle;
  final String amount;
  final String transactionType;
  final String transactionTag;
  final String transactionDate;
  final String transactionPerson;
  final String transactionNote;
  final String transactionAccount;
  final String createdDate;
  static String id = "Transaction Detail Page";
  const TranasctionDetailPage({
    super.key,
    required this.transactionTitle,
    required this.amount,
    required this.transactionType,
    required this.transactionTag,
    required this.transactionDate,
    required this.transactionPerson,
    required this.transactionNote,
    required this.transactionAccount,
    required this.createdDate,
  });

  @override
  State<TranasctionDetailPage> createState() => _TranasctionDetailPageState();
}

class _TranasctionDetailPageState extends State<TranasctionDetailPage> {
  // int index = 0;
  @override
  Widget build(BuildContext context) {
    Database db = Database();
    db.getTransactionDB();
    final index = Database.TransactionList.indexWhere((element) => element[transactionCreatedDateD] == widget.createdDate);
    print(index);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // ignore: unused_local_variable
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditTransaction(
                        transactionTitle: Database.TransactionList[index][transationNameD],
                        amount: Database.TransactionList[index][transactionAmountD].toString(),
                        transactionType: Database.TransactionList[index][transactionTypeD],
                        transactionTag: Database.TransactionList[index][transactionTagD],
                        transactionDate: Database.TransactionList[index][transactionDateD],
                        Account: Database.TransactionList[index][transactionAccountD],
                        transactionPerson: Database.TransactionList[index][transactionPersonD],
                        transactionNote: Database.TransactionList[index][transactionDescriptionD],
                        createdDate: Database.TransactionList[index][transactionCreatedDateD],
                      )));
          // Account: widget.Account,
          // createdDate: widget.createdDate,
          // transactionTitle: widget.transactionTitle,
          // amount: widget.amount,
          // transactionType: widget.transactionType,
          // transactionTag: widget.transactionTag,
          // transactionDate: widget.transactionDate,
          // transactionPerson: widget.transactionPerson,
          // transactionNote: widget.transactionNote)));
          // print("result" + result);
          // if (result != null) {
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
          "Tranasction Detail",
          style: kwhiteboldTextStyle,
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () => {}),
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
                iconsData: Icons.title,
                title: 'Title',
                data: Database.TransactionList[index][transationNameD],
                // data: widget.transactionTitle,
              ),
              DetailField(
                iconsData: Icons.money,
                title: 'Amount',
                data: "RS ${Database.TransactionList[index][transactionAmountD]}",
                // data: "RS ${widget.amount}",
              ),
              DetailField(
                title: 'Transactions type',
                data: Database.TransactionList[index][transactionTypeD],
                // data: widget.transactionType,
                iconsData: Icons.category_outlined,
              ),
              DetailField(
                title: 'Tag',
                data: Database.TransactionList[index][transactionTagD],
                // data: widget.transactionTag,
                iconsData: Icons.tag_rounded,
              ),
              DetailField(
                title: 'Date',
                data: Database.TransactionList[index][transactionDateD],
                // data: widget.transactionDate,
                iconsData: Icons.date_range_outlined,
              ),
              DetailField(
                title: 'Accounts',
                data: Database.TransactionList[index][transactionAccountD],
                // data: widget.Account,
                iconsData: Icons.account_balance_outlined,
              ),
              DetailField(
                title: 'To/From',
                data: Database.TransactionList[index][transactionPersonD],
                // data: widget.transactionPerson,
                iconsData: Icons.person_2_outlined,
              ),
              DetailField(
                title: 'Note',
                data: Database.TransactionList[index][transactionDescriptionD],
                // data: widget.transactionNote,
                iconsData: Icons.fact_check_outlined,
                isNote: true,
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailField extends StatelessWidget {
  final String title;
  final String data;
  final IconData iconsData;
  final bool isNote;
  const DetailField({
    super.key,
    required this.title,
    required this.data,
    required this.iconsData,
    this.isNote = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(child: Icon(iconsData, size: 25)),
        SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title:",
              style: kwhiteTextStyle.copyWith(decoration: TextDecoration.underline),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(data,
                    softWrap: false, maxLines: isNote ? 100 : 1, overflow: TextOverflow.ellipsis, style: kwhiteTextStyle.copyWith(fontSize: 20)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
