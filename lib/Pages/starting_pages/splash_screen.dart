// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, camel_case_types, prefer_const_literals_to_create_immutables, avoid_print

import 'package:expenses_tracker/Componet/logo_viewer.dart';
import 'package:expenses_tracker/Pages/starting_pages/ask_permission_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../introduction_pages/introduction_pages.dart';
import 'check_page.dart';

class Splash_Page extends StatefulWidget {
  static String id = "Splash Page";
  const Splash_Page({Key? key}) : super(key: key);

  @override
  State<Splash_Page> createState() => _Splash_PageState();
}

class _Splash_PageState extends State<Splash_Page> {
  @override
  void initState() {
    super.initState();
    final box = Hive.box("expenses_tracker");
    final bool isDataPresent = box.isNotEmpty;
    _navigatetohome(isDataPresent: isDataPresent);
  }

  late SharedPreferences _prefs;

  Future<bool> _checkFirstTime() async {
    _prefs = await SharedPreferences.getInstance();
    bool isFirstTime = _prefs.getBool('isFirstTime') ?? true;
    setState(() {
      if (isFirstTime) {
        // If it's the first time, set the flag to false
        _prefs.setBool('isFirstTime', false);
      }
    });
    return isFirstTime;
  }

  _navigatetohome({isDataPresent}) async {
    var status = await Permission.storage.status;
    await Future.delayed(Duration(milliseconds: 900), () {});
    status.isGranted
        ? {
            await _checkFirstTime()
                ? Navigator.of(context)
                    .pushReplacement(PageTransition(type: PageTransitionType.fade, duration: Duration(seconds: 1), child: IntroductionPages()))
                : Navigator.of(context)
                    .pushReplacement(PageTransition(type: PageTransitionType.fade, duration: Duration(seconds: 1), child: CheckSignin_outPage()))
          }
        : Navigator.of(context)
            .pushReplacement(PageTransition(type: PageTransitionType.fade, duration: Duration(seconds: 1), child: AskStoragePermission()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // decoration: boxDecoration_backgroundimage,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        LogoViewer(
          side: MediaQuery.of(context).size.height * 0.3,
        ),
      ]),
    )));
  }
}

// class CheckSignin_outPage extends StatelessWidget {
//   const CheckSignin_outPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               customSnackbar(context: context, text: "Something went wrong");
//             }
//             if (snapshot.hasData) {
//               print("checkedpage");
//               return BottomNavigationBars();
//             } else {
//               return LogInSignUpPage();
//             }
//           }),
//     );
//   }
// }
