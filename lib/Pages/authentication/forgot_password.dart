// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, prefer_const_literals_to_create_immutables

import 'package:expenses_tracker/Componet/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../Componet/input_filed.dart';
import '../../constant.dart';

class ForgotPassword extends StatefulWidget {
  static String id = "Forgot Password";
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      customSnackbar(
          context: context, text: "Email Send \nPlease Check Email:\n${emailController.text}", icons: Icons.done, iconsColor: Colors.green);
    } on FirebaseAuthException catch (e) {
      customSnackbar(context: context, text: "Something went wrong: \n${e.code}");
    }
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => setState(() {}));
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {print("${emailController.text} "), FocusScope.of(context).requestFocus(FocusNode())},
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.height * 0.3,
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
                    height: 40,
                  ),
                  Text(
                    "Enter the Email to reset password",
                    style: kwhiteTextStyle.copyWith(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InputField(
                      isrequired: true,
                      hintText: "",
                      controllerss: emailController,
                      keyboardType: TextInputType.emailAddress,
                      labelText: "Email",
                      prefixIcon: Icons.email_outlined),
                  SizedBox(
                    height: 20,
                  ),
                  ProgressButton.icon(
                      textStyle: kwhiteTextStyle,
                      height: 40.00,
                      maxWidth: 200.00,
                      iconedButtons: {
                        ButtonState.idle: IconedButton(
                          text: "Reset Password",
                          icon: Icon(Icons.restore, color: Colors.white),
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
                            if (emailController.text.isEmpty)
                              {
                                customSnackbar(
                                  context: context,
                                  icons: Icons.error,
                                  iconsColor: Colors.red,
                                  text: 'Plese Fill the Email',
                                )
                              }
                            else
                              {_resetPassword()},
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
