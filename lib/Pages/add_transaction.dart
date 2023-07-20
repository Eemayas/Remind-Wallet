// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expenses_tracker/API/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Componet/date_Input_field.dart';
import '../Componet/dropdown_button.dart';
import '../Componet/input_filed.dart';
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

  @override
  void initState() {
    super.initState();
    titleController.addListener(() => setState(() {}));
    amtController.addListener(() => setState(() {}));
    toFromController.addListener(() => setState(() {}));
    noteController.addListener(() => setState(() {}));
    tranasctionTypeController.addListener(() => setState(() {}));
    tagController.addListener(() => setState(() {}));
    dateController.addListener(() => setState(() {}));
  }

  List TransactionTypelist = [incomeT, expensesT, toReceiveT, toPayT];
  List TagList = [
    'Food',
    'Transportation',
    'Housing',
    'Utilities',
    'Healthcare',
    'Education',
    'Entertainment',
    'Clothing',
    'Personal Care',
    'Gifts',
    'Savings',
    'Miscellaneous',
  ];
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
            child: GestureDetector(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                      hintText: "",
                      Controllerss: titleController,
                      keyboardType: TextInputType.text,
                      labelText: "Title",
                      prefixIcon: Icons.title_sharp),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
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
                    iconsName: Icons.category_outlined,
                    lists: TransactionTypelist,
                    Controllerss: tranasctionTypeController,
                    hintText: "Income/Expense/To Pay/To Receives",
                    labelText: "Tranaction Type",
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
                  // HomePage()
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
