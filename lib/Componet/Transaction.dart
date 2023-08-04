// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, must_be_immutable

import 'package:expenses_tracker/API/database.dart';
import 'package:expenses_tracker/Pages/transaction_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

import '../Provider/provider.dart';
import '../constant.dart';

class TranactionCard extends StatelessWidget {
  // final Color boxShadowColor;
  final String transationName;
  final String transactionTag;
  final String transactionDescription;
  final String transactionAccount;
  final IconData iconsName;
  final String transactionType;
  final String transactionPerson;
  final String transactionAmount;
  // final String Account;
  final String transactionCreatedDate;

  final String transactionDate;
  TranactionCard({
    super.key,
    required this.transationName,
    required this.transactionTag,
    required this.transactionDescription,
    required this.transactionAccount,
    required this.iconsName,
    required this.transactionType,
    required this.transactionPerson,
    required this.transactionAmount,
    required this.transactionDate,
    required this.transactionCreatedDate, // this.Account = "Cash",
  });
  Database db = Database();
  @override
  Widget build(BuildContext context) {
    Color cardMainColor = transactionType == incomeT || transactionType == toReceiveT ? kColorIncome : kColorExpenses;
    Color boxShadowColor = transactionType == incomeT || transactionType == toReceiveT ? kBoxShadowIncome : kBoxShadowExpenses;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TranasctionDetailPage(
                    createdDate: transactionCreatedDate,
                    transactionTitle: transationName,
                    amount: transactionAmount,
                    transactionType: transactionType,
                    transactionTag: transactionTag,
                    transactionPerson: transactionPerson,
                    transactionDate: transactionDate,
                    transactionNote: transactionDescription,
                    transactionAccount: transactionAccount,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: 200,
          decoration: BoxDecoration(
            color: kBackgroundColorCard,
            border: Border.all(color: Colors.transparent, width: 2),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                offset: Offset(6, 6),
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 91, 90, 90),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Icon(
                        iconsName,
                        color: Colors.white,
                        size: 40,
                      )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(transationName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kwhiteTextStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w300)),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(transactionAmount,
                                    textDirection: TextDirection.rtl,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kwhiteTextStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w300, color: cardMainColor)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Text("TO/FROM-$transactionPerson",
                              maxLines: 2, overflow: TextOverflow.ellipsis, style: ksubTextStyle.copyWith(fontSize: 7, fontWeight: FontWeight.w300)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text("($transactionTag)-$transactionDescription",
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: ksubTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w300)),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(transactionDate,
                                    textDirection: TextDirection.rtl,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: ksubTextStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w300)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardMainColor),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Center(
                                        child: Text(transactionType,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kwhiteTextStyle.copyWith(
                                                color: cardMainColor == kColorIncome ? Colors.black : Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300)),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardMainColor),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: Center(
                                        child: Text(transactionAccount,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kwhiteTextStyle.copyWith(
                                                color: cardMainColor == kColorIncome ? Colors.black : Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  // ignore: dead_code
                  visible: (transactionType == toReceiveT || transactionType == toPayT) ? true : false,
                  child: Column(
                    children: [
                      Divider(
                        thickness: 2,
                        color: Color.fromARGB(255, 135, 135, 135),
                      ),
                      ProgressButton.icon(
                          textStyle: kwhiteTextStyle,
                          height: 35.00,
                          iconedButtons: {
                            ButtonState.idle: IconedButton(
                              text: "Completed",
                              icon: Icon(Icons.done_all_outlined, color: Colors.white),
                              color: Colors.deepPurple.shade500,
                            ),
                            ButtonState.loading: IconedButton(text: "Loading", color: Colors.deepPurple.shade700),
                            ButtonState.fail: IconedButton(text: "Failed", icon: Icon(Icons.cancel, color: Colors.white), color: Colors.red.shade300),
                            ButtonState.success: IconedButton(
                                text: "Success",
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                color: Colors.green.shade400)
                          },
                          onPressed: () => {
                                db.onCompletedClicked(
                                    updated_transactionTitle: transationName,
                                    updated_amount: transactionAccount,
                                    updated_transactionType: transactionType,
                                    updated_transactionTag: transactionTag,
                                    updated_transactionDate: transactionDate,
                                    updated_transactionPerson: transactionPerson,
                                    updated_transactionNote: transactionDescription,
                                    updated_account: transactionAccount,
                                    createdDate: transactionCreatedDate),
                                context.read<ChangedMsg>().changed()
                              },
                          state: ButtonState.idle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
