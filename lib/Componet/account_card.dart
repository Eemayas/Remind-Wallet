import 'package:flutter/material.dart';

import '../constant.dart';

class AccountCard extends StatelessWidget {
  final String cardDetail;
  final String amount;
  final Color color;
  final Icon icons;
  final Color borderColor;
  final Color boxShadowColor;
  final Color iconBgColor;
  final String accountName;

  const AccountCard(
      {super.key,
      required this.cardDetail,
      required this.amount,
      required this.color,
      required this.icons,
      required this.borderColor,
      required this.boxShadowColor,
      required this.iconBgColor,
      required this.accountName});
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    child: Text(accountName,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kwhiteTextStyle.copyWith(
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("CURRENT BALANCE",
                  style: ksubTextStyle.copyWith(
                      fontSize: 10, fontWeight: FontWeight.w300)),
              SizedBox(
                height: 10,
              ),
              Text('Rs $amount ',
                  style: kwhiteTextStyle.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
