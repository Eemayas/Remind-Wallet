// ignore_for_file: prefer_const_constructors, unused_import, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../API/database.dart';
import '../Componet/input_filed.dart';
import '../constant.dart';

class UserDataEntryPage extends StatefulWidget {
  static String id = "user_data_entry";

  @override
  State<UserDataEntryPage> createState() => _UserDataEntryPageState();
}

class _UserDataEntryPageState extends State<UserDataEntryPage> {
  final userNameController = TextEditingController();

  _addUserData() {
    print("${userNameController.text}  ");
    Database db = Database();
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
                'Username Added',
                style: kwhiteTextStyle.copyWith(color: Colors.red),
              ),
            ],
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    userNameController.addListener(() => setState(() {}));
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
            style: kwhiteTextStyle,
          ),
          actions: [
            IconButton(icon: Icon(Icons.more_vert), onPressed: () => {}),
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputField(
                      isrequired: true,
                      hintText: "",
                      Controllerss: userNameController,
                      keyboardType: TextInputType.text,
                      labelText: "Name",
                      prefixIcon: Icons.title_sharp),
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
                                            'Plese Enter your name',
                                            style: kwhiteTextStyle.copyWith(color: Colors.red),
                                          ),
                                        ],
                                      )),
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
    );
  }
}
