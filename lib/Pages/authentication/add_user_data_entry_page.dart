// ignore_for_file: prefer_const_constructors, unused_import, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:expenses_tracker/Componet/custom_snackbar.dart';
import 'package:expenses_tracker/Pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../API/database.dart';
import '../../Componet/date_input_field.dart';
import '../../Componet/input_filed.dart';
import '../../constant.dart';

class UserDataEntryPage extends StatefulWidget {
  static String id = "user_data_entry";

  @override
  State<UserDataEntryPage> createState() => _UserDataEntryPageState();
}

class _UserDataEntryPageState extends State<UserDataEntryPage> {
  final userNameController = TextEditingController();
  final titleController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final toFromController = TextEditingController();
  final noteController = TextEditingController();
  final tranasctionTypeController = TextEditingController();
  final tagController = TextEditingController();
  final dateController = TextEditingController();
  final accountController = TextEditingController();
  Database db = Database();
  _addUserData() {
    print("${userNameController.text}  ");

    db.addUserDB(
        userName: userNameController.text, userDOB: dateController.text, userEmail: "xyz@example.com", userPhoneNumber: phoneNumberController.text);
    db.getUserNameDB();
    customSnackbar(context: context, text: "User Detail was Successful Added", icons: Icons.done_all, iconsColor: Colors.green);
    Navigator.pop(context);
    Navigator.pushNamed(context, Dashboard.id);
  }

  @override
  void initState() {
    super.initState();
    userNameController.addListener(() => setState(() {}));
    titleController.addListener(() => setState(() {}));
    phoneNumberController.addListener(() => setState(() {}));
    toFromController.addListener(() => setState(() {}));
    noteController.addListener(() => setState(() {}));
    tranasctionTypeController.addListener(() => setState(() {}));
    tagController.addListener(() => setState(() {}));
    // dateController.addListener(() => setState(() {}));
    accountController.addListener(() => setState(() {}));
    // db.deleteAll();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).requestFocus(FocusNode())},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColorAppBar,
          title: Text(
            "User Detail",
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
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: const Offset(10.0, 10.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          )
                        ],
                        image: DecorationImage(image: AssetImage("assets/Logo/png/logo-white.png"), fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    InputField(
                        isrequired: true,
                        hintText: "",
                        controllerss: userNameController,
                        keyboardType: TextInputType.text,
                        labelText: "Name",
                        prefixIcon: Icons.person_2),
                    SizedBox(
                      height: 20,
                    ),
                    InputField(
                      isrequired: true,
                      controllerss: phoneNumberController,
                      keyboardType: TextInputType.number,
                      labelText: "Phone Number",
                      prefixIcon: Icons.money,
                      hintText: "9800000000",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DateInputField(
                      controllerss: dateController,
                      keyboardType: TextInputType.datetime,
                      labelText: "Date of Birth",
                      prefixIcon: Icons.date_range_outlined,
                      hintText: "YYYY-MM-DD",
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
                            text: "Continue",
                            icon: Icon(Icons.navigate_next_outlined, color: Colors.white),
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
                              if (userNameController.text.isEmpty)
                                {
                                  customSnackbar(
                                    context: context,
                                    text: 'Plese Enter your name',
                                  )
                                }
                              else if (phoneNumberController.text.isEmpty)
                                {
                                  customSnackbar(
                                    context: context,
                                    text: 'Plese Enter your phone number',
                                  )
                                }
                              else if (dateController.text.isEmpty)
                                {
                                  customSnackbar(
                                    context: context,
                                    text: 'Plese Enter your date of birth',
                                  )
                                }
                              else
                                {_addUserData()},
                            },
                        state: ButtonState.idle),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
