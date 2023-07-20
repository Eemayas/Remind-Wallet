// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:expenses_tracker/Pages/add_transaction.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:flutter/material.dart';

class TranasctionDetailPage extends StatelessWidget {
  final String transactionTitle;
  final String amount;
  final String transactionType;
  final String transactionTag;
  final String transactionDate;
  final String transactionPerson;
  final String transactionNote;
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
  });

  @override
  Widget build(BuildContext context) {
    // var transactionTitle = "Transactions Title";
    // var amount = '00,000';
    // var transactionType = incomeT;
    // var transactionTag = " TagList ";
    // var transactionDate = "YYYY-MM-DD";
    // var transactionPerson = "Person Name";
    // var transactionNote =
    //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam pulvinar elit in eros consequat, vitae porta tellus lobortis. Nulla laoreet id orci ac aliquam.";
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AddTransaction.id);
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
          style: kwhiteTextStyle,
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
                data: transactionTitle,
              ),
              DetailField(
                iconsData: Icons.money,
                title: 'Amount',
                data: "RS $amount",
              ),
              DetailField(
                title: 'Transactions type',
                data: transactionType,
                iconsData: Icons.category_outlined,
              ),
              DetailField(
                title: 'Tag',
                data: transactionTag,
                iconsData: Icons.tag_rounded,
              ),
              DetailField(
                title: 'Date',
                data: transactionDate,
                iconsData: Icons.date_range_outlined,
              ),
              DetailField(
                title: 'To/From',
                data: transactionPerson,
                iconsData: Icons.person_2_outlined,
              ),
              DetailField(
                title: 'Note',
                data: transactionNote,
                iconsData: Icons.fact_check_outlined,
                isNote: true,
              ),
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
              "${title}:",
              style: kwhiteTextStyle.copyWith(
                  decoration: TextDecoration.underline),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(data,
                    softWrap: false,
                    maxLines: isNote ? 4 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: kwhiteTextStyle.copyWith(fontSize: 20)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
