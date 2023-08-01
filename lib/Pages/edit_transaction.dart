// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

import '../API/database.dart';
import '../Componet/date_input_field.dart';
import '../Componet/dropdown_button.dart';
import '../Componet/input_filed.dart';
import '../Provider/provider.dart';
import '../constant.dart';

class EditTransaction extends StatefulWidget {
  static String id = "Add Transaction page";
  final String transactionTitle;
  final String amount;
  final String transactionType;
  final String transactionTag;
  final String transactionDate;
  final String transactionPerson;
  final String transactionNote;
  final String Account;
  final String createdDate;
  const EditTransaction(
      {super.key,
      required this.transactionTitle,
      required this.amount,
      required this.transactionType,
      required this.transactionTag,
      required this.transactionDate,
      required this.transactionPerson,
      required this.transactionNote,
      required this.Account,
      required this.createdDate});

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final titleController = TextEditingController();
  final amtController = TextEditingController();
  final toFromController = TextEditingController();
  final noteController = TextEditingController();
  final tranasctionTypeController = TextEditingController();
  final tagController = TextEditingController();
  final dateController = TextEditingController();
  final accountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.addListener(() => setState(() {}));
    amtController.addListener(() => setState(() {}));
    toFromController.addListener(() => setState(() {}));
    noteController.addListener(() => setState(() {}));
    tranasctionTypeController.addListener(() => setState(() {}));
    // tagController.addListener(() => setState(() {}));
    // dateController.addListener(() => setState(() {}));
    accountController.addListener(() => setState(() {}));

    titleController.text = widget.transactionTitle;
    amtController.text = widget.amount;
    tranasctionTypeController.text = widget.transactionType;
    // tagController.text = widget.transactionTag;
    // dateController.text = widget.transactionDate;
    toFromController.text = widget.transactionPerson;
    noteController.text = widget.transactionNote;
    // Database db = Database();
  }

  @override
  Widget build(BuildContext context) {
    Database db = Database();
    dateController.text = widget.transactionDate;
    // tagController.text = widget.transactionTag;
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
            "Edit Transaction",
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
                      isrequired: true,
                      hintText: "",
                      controllerss: titleController,
                      keyboardType: TextInputType.text,
                      labelText: "Title",
                      prefixIcon: Icons.title_sharp),
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
                  DropDownButton(
                    isrequired: true,
                    iconsName: Icons.category_outlined,
                    lists: TransactionTypelist,
                    controllerss: tranasctionTypeController,
                    hintText: "Income/Expense/To Pay/To Receives",
                    labelText: "Tranaction Type",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropDownButton(
                    iconsName: Icons.tag_rounded,
                    lists: TagList,
                    controllerss: tagController,
                    hintText:
                        " Food/Transportation/Housing/Utilities/Healthcare/Education/Entertainment/Clothing/Personal Care/Gifts/Savings/Miscellaneous",
                    labelText: "Tag",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropDownButton(
                    iconsName: Icons.account_balance_outlined,
                    lists: Accountlist,
                    controllerss: accountController,
                    hintText: "Cash/Esewa/Khalti",
                    labelText: "Account",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DateInputField(
                    controllerss: dateController,
                    keyboardType: TextInputType.datetime,
                    labelText: "When",
                    prefixIcon: Icons.date_range_outlined,
                    hintText: "YYYY-MM-DD",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    controllerss: toFromController,
                    keyboardType: TextInputType.text,
                    labelText: "To/From",
                    prefixIcon: Icons.person_2_outlined,
                    hintText: "Prashant, Ram",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                    controllerss: noteController,
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
                          text: "Edit Transaction",
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
                              {
                                db.editTransactionDB(
                                  updated_transactionTitle: titleController.text,
                                  updated_amount: amtController.text,
                                  updated_transactionType: tranasctionTypeController.text,
                                  updated_transactionTag: tagController.text,
                                  updated_transactionDate: dateController.text,
                                  updated_transactionPerson: toFromController.text,
                                  updated_transactionNote: noteController.text,
                                  updated_account: accountController.text,
                                  createdDate: widget.createdDate,
                                ),
                                context.read<ChangedMsg>().changed(),
                                Navigator.pop(context, "here i am"),
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
