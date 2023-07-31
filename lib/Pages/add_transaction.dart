// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, avoid_print

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expenses_tracker/API/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

import '../API/database.dart';
import '../Componet/date_Input_field.dart';
import '../Componet/dropdown_button.dart';
import '../Componet/input_filed.dart';
import '../Provider/provider.dart';
import '../constant.dart';

class AddTransaction extends StatefulWidget {
  static String id = "Add Transaction page";

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final titleController = TextEditingController();
  final amtController = TextEditingController();
  final toFromController = TextEditingController();
  final noteController = TextEditingController();
  final tranasctionTypeController = TextEditingController();
  final tagController = TextEditingController();
  final dateController = TextEditingController();
  final accountController = TextEditingController();
  _addTransaction() {
    print(
        "${titleController.text}  ${amtController.text}  ${tranasctionTypeController.text}  ${tagController.text}  ${dateController.text}  ${toFromController.text}  ${noteController.text}  ");
    Database db = Database();
    db.addTransactionDB(
      createdDate: DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now()),
      amount: int.tryParse(amtController.text),
      transactionDate: dateController.text,
      transactionNote: noteController.text,
      transactionPerson: toFromController.text,
      transactionTag: tagController.text,
      transactionTitle: titleController.text,
      transactionType: tranasctionTypeController.text,
      account: accountController.text,
    );
    print("addedddddd");
    context.read<ChangedMsg>().changed();
    Navigator.pop(context, "here i am");
  }

  @override
  void initState() {
    super.initState();
    titleController.addListener(() => setState(() {}));
    amtController.addListener(() => setState(() {}));
    toFromController.addListener(() => setState(() {}));
    noteController.addListener(() => setState(() {}));
    tranasctionTypeController.addListener(() => setState(() {}));
    tagController.addListener(() => setState(() {}));
    // dateController.addListener(() => setState(() {}));
    accountController.addListener(() => setState(() {}));
  }

  Database db = Database();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        print(
            "${titleController.text}  ${amtController.text} ${toFromController.text}  ${noteController.text}  ${tranasctionTypeController.text}  ${tagController.text}  ${dateController.text}"),
        FocusScope.of(context).requestFocus(FocusNode())
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColorAppBar,
          title: Text(
            "Add Transaction",
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InputField(
                      isrequired: true,
                      hintText: "",
                      Controllerss: titleController,
                      keyboardType: TextInputType.text,
                      labelText: "Title",
                      prefixIcon: Icons.title_sharp),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    isrequired: true,
                    Controllerss: amtController,
                    keyboardType: TextInputType.number,
                    labelText: "Amount",
                    prefixIcon: Icons.money,
                    hintText: "00000",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropDownButton(
                    isrequired: true,
                    iconsName: Icons.category_outlined,
                    lists: TransactionTypelist,
                    Controllerss: tranasctionTypeController,
                    hintText: "Income/Expense/To Pay/To Receives",
                    labelText: "Transaction Type",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropDownButton(
                    iconsName: Icons.tag_rounded,
                    lists: TagList,
                    Controllerss: tagController,
                    hintText:
                        " Food/Transportation/Housing/Utilities/Healthcare/Education/Entertainment/Clothing/Personal Care/Gifts/Savings/Miscellaneous",
                    labelText: "Tag",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropDownButton(
                    iconsName: Icons.account_balance_outlined,
                    lists: db.getAccountNameListDB(), //Accountlist,
                    Controllerss: accountController,
                    hintText: "Cash/Esewa/Khalti",
                    labelText: "Account",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DateInputField(
                    Controllerss: dateController,
                    keyboardType: TextInputType.datetime,
                    labelText: "When",
                    prefixIcon: Icons.date_range_outlined,
                    hintText: "YYYY-MM-DD",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    Controllerss: toFromController,
                    keyboardType: TextInputType.text,
                    labelText: "To/From",
                    prefixIcon: Icons.person_2_outlined,
                    hintText: "Prashant, Ram",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    Controllerss: noteController,
                    keyboardType: TextInputType.text,
                    labelText: "Notes",
                    prefixIcon: Icons.fact_check_outlined,
                    hintText:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam pulvinar elit in eros consequat, vitae porta tellus lobortis. Nulla laoreet id orci ac aliquam.",
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
                          text: "Add Transaction",
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
                            FocusScope.of(context).requestFocus(FocusNode()),
                            if (titleController.text.isEmpty)
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
                            else if (tranasctionTypeController.text.isEmpty)
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
                                            'Plese choose one Tranasction type',
                                            style: kwhiteTextStyle,
                                          ),
                                        ],
                                      )),
                                )
                              }
                            else
                              {_addTransaction()},
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

class SnackMsg extends StatelessWidget {
  const SnackMsg({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
