// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, camel_case_types

import 'package:expenses_tracker/Pages/dashboard.dart';
import 'package:expenses_tracker/Pages/user_data_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';

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

  _navigatetohome({isDataPresent}) async {
    await Future.delayed(Duration(milliseconds: 900), () {});
    Navigator.of(context).pushReplacement(
        PageTransition(type: PageTransitionType.fade, duration: Duration(seconds: 1), child: isDataPresent ? Dashboard() : UserDataEntryPage()));

    //context, MaterialPageRoute( builder: (builder) => Starting_Page_1()));
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
        )
      ]),
    )));
  }
}
