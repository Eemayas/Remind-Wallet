// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../API/database.dart';
import '../Componet/custom_snackbar.dart';
import '../Componet/date_input_field.dart';
import '../Componet/input_filed.dart';
import '../constant.dart';

class EditUserDetail extends StatefulWidget {
  static String id = "edit-user-detail";
  const EditUserDetail({super.key});

  @override
  State<EditUserDetail> createState() => _EditUserDetailState();
}

class _EditUserDetailState extends State<EditUserDetail> {
  final userNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();
  Database db = Database();
  _editUserData() {
    // ignore: avoid_print

    db.editUserNameDB(
        updated_userName: userNameController.text,
        updated_userDOB: dateController.text,
        updated_userEmail: emailController.text,
        updated_userPhoneNumber: phoneNumberController.text);
    db.getUserNameDB();
    customSnackbar(context: context, text: "User Detail was Successful updated", icons: Icons.done_all, iconsColor: Colors.green);
    // Navigator.pop(context);
    // Navigator.pushNamed(context, Dashboard.id);
  }

  @override
  void initState() {
    super.initState();
    userNameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    phoneNumberController.addListener(() => setState(() {}));
    db.getUserNameDB();
    userNameController.text = db.userDetail[userNameD];
    dateController.text = db.userDetail[userDOBD];
    phoneNumberController.text = db.userDetail[userPhoneD];
    emailController.text = db.userDetail[userEmailD];
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
            "Edit User Detail",
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
                    InputField(
                      isrequired: true,
                      controllerss: emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: "Email Address",
                      prefixIcon: Icons.email_outlined,
                      hintText: "xyz@example.com",
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
                                {_editUserData()},
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
