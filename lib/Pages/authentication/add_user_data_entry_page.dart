// ignore_for_file: prefer_const_constructors, unused_import, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:expenses_tracker/API/firebase_databse.dart';
import 'package:expenses_tracker/Componet/custom_snackbar.dart';
import 'package:expenses_tracker/Componet/logo_viewer.dart';
import 'package:expenses_tracker/Pages/starting_pages/check_page.dart';
import 'package:expenses_tracker/Pages/home_pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../API/database.dart';
import '../../Componet/date_input_field.dart';
import '../../Componet/input_filed.dart';
import '../../constant.dart';
import '../home_pages/bottom_navigation_bar.dart';

class AddUserDataPage extends StatefulWidget {
  static String id = "user_data_entry";

  @override
  State<AddUserDataPage> createState() => _AddUserDataPageState();
}

class _AddUserDataPageState extends State<AddUserDataPage> {
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
  FirebaseDatabases fd = FirebaseDatabases();
  _addUserData() async {
    EasyLoading.show(
      status: 'Adding user data',
      maskType: EasyLoadingMaskType.black,
    );
    print("${userNameController.text}  ");

    db.addUserDB(
        userName: userNameController.text, userDOB: dateController.text, userEmail: currentEmail, userPhoneNumber: phoneNumberController.text);
    db.getUserDetailDB();
    print(Database.userDetail);
    if (await fd.saveUserDetailToFirebase(context)) {
      EasyLoading.dismiss();
      customSnackbar(context: context, text: "User Detail was Successful Added", icons: Icons.done_all, iconsColor: Colors.green);
      Navigator.pushReplacementNamed(context, BottomNavigationBars.id);
    }
  }

  String currentEmail = "xyz@example.com";
  void getCurrentUserEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      currentEmail = user.email!;
      print('Current User Email: $currentEmail');
    } else {
      Navigator.pop(context);
      print('No user is currently logged in.');
    }
  }

  @override
  void initState() {
    getCurrentUserEmail();
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
                    LogoViewer(side: 200),
                    SizedBox(
                      height: 60,
                    ),
                    InputField(
                        isrequired: true,
                        hintText: "",
                        controllerss: userNameController,
                        keyboardType: TextInputType.text,
                        labelText: "Name",
                        textCapitalization: TextCapitalization.words,
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
                       dateinput: DateTime.now(),
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
