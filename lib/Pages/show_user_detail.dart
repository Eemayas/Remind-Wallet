// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:expenses_tracker/Pages/edit_user_detail.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import '../API/database.dart';
import '../Componet/date_input_field.dart';
import '../Componet/input_filed.dart';
import '../Componet/logo_viewer.dart';
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
    db.getUserDetailDB();
    userNameController.text = db.userDetail[userNameD];
    dateController.text = db.userDetail[userDOBD];
    phoneNumberController.text = db.userDetail[userPhoneD];
    emailController.text = db.userDetail[userEmailD];

    // ignore: non_constant_identifier_names
    final FormKey = GlobalKey<FormState>();

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
              key: FormKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LogoViewer(
                      side: 200,
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    InputField(
                        isUserDetail: true,
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
                      isUserDetail: true,
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
                      isUserDetail: true,
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
                      isUserDetail: true,
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
                    CustomButton(
                      label: "Edit User Details",
                      icons: Icons.edit_square,
                      onTap: () {
                        Navigator.pushNamed(context, EditUserDetail.id);
                      },
                    )
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

class CustomButton extends StatelessWidget {
  final String label;
  final double height;
  final double maxWidth;
  final IconData icons;
  final Color iconColor;
  final Function? onTap;
  const CustomButton({
    super.key,
    required this.label,
    this.height = 40.00,
    this.maxWidth = 200.00,
    required this.icons,
    this.iconColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressButton.icon(
        textStyle: kwhiteTextStyle,
        height: height,
        maxWidth: maxWidth,
        iconedButtons: {
          ButtonState.idle: IconedButton(
            text: label,
            icon: Icon(icons, color: iconColor),
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
        onPressed: onTap);
  }
}
