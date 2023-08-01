// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

import '../API/database.dart';
import '../Componet/date_input_field.dart';
import '../Componet/input_filed.dart';
import '../constant.dart';

class ShowUserDetailPage extends StatelessWidget {
  static String id = "show user detail page";
  const ShowUserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final dateController = TextEditingController();
    final emailController = TextEditingController();
    Database db = Database();
    db.getUserNameDB();
    userNameController.text = db.userDetail[userNameD];
    dateController.text = db.userDetail[userDOBD];
    phoneNumberController.text = db.userDetail[userPhoneD];
    emailController.text = db.userDetail[userEmailD];

    final _formKey = GlobalKey<FormState>();

    // @override
    // Widget build(BuildContext context) {
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
                        isEnable: false,
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
                      isEnable: false,
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
                      isEnable: false,
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
                      isEnable: false,
                      controllerss: dateController,
                      keyboardType: TextInputType.datetime,
                      labelText: "Date of Birth",
                      prefixIcon: Icons.date_range_outlined,
                      hintText: "YYYY-MM-DD",
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
