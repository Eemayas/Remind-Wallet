// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, camel_case_types

// import 'package:expenses_tracker/Pages/dashboard.dart';
// import 'package:expenses_tracker/Pages/authentication/add_user_data_entry_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

import '../../Componet/bottom_navigation_bar.dart';
import '../../Componet/custom_snackbar.dart';
import '../authentication/signIn_signOut_page.dart';

// class CheckPage extends StatelessWidget {
//   static String id = "Check Page";
//   @override
//   Widget build(BuildContext context) {
//     final box = Hive.box("expenses_tracker"); // Replace 'myData' with your box name

//     // Check if data is present in the box
//     final bool isDataPresent = box.isNotEmpty;

//     return MaterialApp(
//       home: isDataPresent ? const Dashboard() : AddUserDataPage(),
//     );
//   }
// }

class CheckSignin_outPage extends StatelessWidget {
  static String id = "Check Page";
  const CheckSignin_outPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              customSnackbar(context: context, text: "Something went wrong");
            }
            if (snapshot.hasData) {
              // ignore: avoid_print
              print("checkedpage");
              return BottomNavigationBars();
            } else {
              return LogInSignUpPage();
            }
          }),
    );
  }
}
