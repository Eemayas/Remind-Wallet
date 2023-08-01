// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

import '../API/database.dart';
import '../Componet/input_filed.dart';
import '../Provider/provider.dart';
import '../constant.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key, required this.accountName, required this.amount});
  final String accountName;
  final String amount;

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final accountNameController = TextEditingController();
  final amtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    accountNameController.addListener(() => setState(() {}));
    amtController.addListener(() => setState(() {}));
    accountNameController.text = widget.accountName;
    amtController.text = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    Database db = Database();
    return GestureDetector(
      onTap: () => {print("${accountNameController.text}  ${amtController.text} "), FocusScope.of(context).requestFocus(FocusNode())},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColorAppBar,
          title: Text(
            "Edit Account",
            style: kwhiteTextStyle,
          ),
          actions: [
            IconButton(icon: Icon(Icons.more_vert), onPressed: () => {}),
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InputField(
                      isrequired: true,
                      hintText: "",
                      controllerss: accountNameController,
                      keyboardType: TextInputType.text,
                      labelText: "Title",
                      prefixIcon: Icons.account_balance_outlined),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    isrequired: true,
                    controllerss: amtController,
                    keyboardType: TextInputType.number,
                    labelText: "Amount",
                    prefixIcon: Icons.money,
                    hintText: "00000",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ProgressButton.icon(
                      textStyle: kwhiteTextStyle,
                      height: 40.00,
                      maxWidth: 200.00,
                      iconedButtons: {
                        ButtonState.idle: IconedButton(
                          text: "Edit Account",
                          icon: Icon(Icons.edit, color: Colors.white),
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
                            FocusScope.of(context).requestFocus(FocusNode()),
                            if (accountNameController.text.isEmpty)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: kBackgroundColorCard,
                                      content: Row(
                                        children: [
                                          Icon(Icons.error, color: Colors.red),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Plese Fill the Account Name',
                                            style: kwhiteTextStyle.copyWith(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                )
                              }
                            else if (amtController.text.isEmpty)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: kBackgroundColorCard,
                                      content: Row(
                                        children: [
                                          Icon(Icons.error, color: Colors.red),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Plese Fill the amount',
                                            style: kwhiteTextStyle,
                                          ),
                                        ],
                                      )),
                                )
                              }
                            else
                              {
                                db.editAccountDB(
                                    accountName: widget.accountName,
                                    amount: widget.amount,
                                    updated_accountName: accountNameController.text,
                                    updated_amount: amtController.text),
                                context.read<ChangedMsg>().changed(),
                                Navigator.pop(context, "here i am"),
                                // Navigator.pop(context, "here i am"),
                                // Navigator.pop(context, "here i am"),
                              },
                          },
                      state: ButtonState.idle),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
