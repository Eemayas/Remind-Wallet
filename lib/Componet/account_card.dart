// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';

import '../API/database.dart';
import '../Pages/account_detail_page.dart';
import '../constant.dart';

class AccountCard extends StatefulWidget {
  final String amount;
  final String accountName;

  const AccountCard({super.key, required this.amount, required this.accountName});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  Database db = Database();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        db.getAccountDB();
        final index = db.AccountsList.indexWhere(
            (element) => element[accountNameD] == widget.accountName && element[accountCurrentBalanceD].toString() == widget.amount);
        print(index);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowAccountDetailPage(
                      index: index,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kBackgroundColorCard,
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
                      child: Text(widget.accountName,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kwhiteTextStyle.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text("CURRENT BALANCE", style: ksubTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w300)),
                SizedBox(
                  height: 10,
                ),
                Text('Rs ${widget.amount} ', style: kwhiteTextStyle.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
