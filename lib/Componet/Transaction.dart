// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:expenses_tracker/Pages/transaction_detail_page.dart';
import 'package:flutter/material.dart';

import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../constant.dart';

class TranactionCard extends StatelessWidget {
  // final Color boxShadowColor;
  final String transationName;
  final String transactionTag;
  final String transactionDescription;
  final String transactionTags;
  final IconData iconsName;
  final String Category;
  final String toFromName;
  final String Amount;
  final String Account;

  final String transactionDate;
  const TranactionCard({
    super.key,
    required this.transationName,
    required this.transactionTag,
    required this.transactionDescription,
    required this.transactionTags,
    required this.iconsName,
    required this.Category,
    required this.toFromName,
    required this.Amount,
    required this.transactionDate,
    this.Account = "Cash",
  });

  @override
  Widget build(BuildContext context) {
    Color tagColor = Category == incomeT || Category == toReceiveT
        ? kColorIncome
        : kColorExpenses;
    Color boxShadowColor = Category == incomeT || Category == toReceiveT
        ? kBoxShadowIncome
        : kBoxShadowExpenses;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TranasctionDetailPage(
                    transactionTitle: transationName,
                    amount: Amount,
                    transactionType: Category,
                    transactionTag: transactionTag,
                    transactionPerson: toFromName,
                    transactionDate: transactionDate,
                    transactionNote: transactionDescription,
                    Account: Account,
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
                                    style: kwhiteTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300)),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(Amount,
                                    textDirection: TextDirection.rtl,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kwhiteTextStyle.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: tagColor)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Text("TO/FROM-$toFromName",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: ksubTextStyle.copyWith(
                                  fontSize: 7, fontWeight: FontWeight.w300)),
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
                                child: Text(
                                    "($transactionTag)-$transactionDescription",
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: ksubTextStyle.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300)),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(transactionDate,
                                    textDirection: TextDirection.rtl,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: ksubTextStyle.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300)),
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
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: tagColor),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Center(
                                        child: Text(Category,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kwhiteTextStyle.copyWith(
                                                color: tagColor == kColorIncome
                                                    ? Colors.black
                                                    : Colors.white,
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
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: tagColor),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Center(
                                        child: Text(transactionTags,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: kwhiteTextStyle.copyWith(
                                                color: tagColor == kColorIncome
                                                    ? Colors.black
                                                    : Colors.white,
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
                  visible: (Category == toReceiveT || Category == toPayT)
                      ? true
                      : false,
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
                              icon: Icon(Icons.done_all_outlined,
                                  color: Colors.white),
                              color: Colors.deepPurple.shade500,
                            ),
                            ButtonState.loading: IconedButton(
                                text: "Loading",
                                color: Colors.deepPurple.shade700),
                            ButtonState.fail: IconedButton(
                                text: "Failed",
                                icon: Icon(Icons.cancel, color: Colors.white),
                                color: Colors.red.shade300),
                            ButtonState.success: IconedButton(
                                text: "Success",
                                icon: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                color: Colors.green.shade400)
                          },
                          onPressed: () => {print("Pressed")},
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
