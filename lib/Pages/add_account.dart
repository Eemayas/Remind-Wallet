// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, avoid_print

import 'package:expenses_tracker/Componet/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

import '../API/database.dart';
import '../Componet/input_filed.dart';
import '../Provider/provider.dart';
import '../constant.dart';

class AddAccount extends StatefulWidget {
  static String id = "Add Account";

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final accountnameController = TextEditingController();
  final amtController = TextEditingController();

  _addAccount() {
    Database db = Database();
    print("${accountnameController.text}  ${int.tryParse(amtController.text)}   ");
    bool isSucessfull = db.addAccountDB(accountName: accountnameController.text, amount: int.tryParse(amtController.text));
    print("addedddddd");
    context.read<ChangedMsg>().changed();
    Navigator.pop(context, "added");
    if (isSucessfull) {
      customSnackbar(
        context: context,
        text: "Account is sucessfull added",
        icons: Icons.done_all,
        iconsColor: Colors.green,
      );
    } else {
      customSnackbar(context: context, text: "Error:Account is not added. \nTry changing the name");
    }
  }

  @override
  void initState() {
    super.initState();
    accountnameController.addListener(() => setState(() {}));
    amtController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {print("${accountnameController.text}  ${amtController.text}   "), FocusScope.of(context).requestFocus(FocusNode())},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColorAppBar,
          title: Text(
            "Add Account",
            style: kwhiteboldTextStyle,
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
                      hintText: "Esewa/Khalti",
                      controllerss: accountnameController,
                      keyboardType: TextInputType.text,
                      labelText: "Account Name",
                      prefixIcon: Icons.account_balance_outlined),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    controllerss: amtController,
                    keyboardType: TextInputType.number,
                    labelText: "Amount",
                    prefixIcon: Icons.money,
                    hintText: "00000",
                  ),
                  SizedBox(
                    height: 20,
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
                          text: "Add Account",
                          icon: Icon(Icons.add, color: Colors.white),
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
                            if (accountnameController.text.isEmpty)
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
                                            'Plese Fill the title',
                                            style: kwhiteTextStyle.copyWith(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                )
                              }
                            else
                              {_addAccount()},
                            FocusScope.of(context).requestFocus(FocusNode())
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
