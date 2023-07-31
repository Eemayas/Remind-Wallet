// ignore_for_file: use_key_in_widget_constructors

import 'package:expenses_tracker/Pages/dashboard.dart';
import 'package:expenses_tracker/Pages/user_data_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CheckPage extends StatelessWidget {
  static String id = "Check Page";
  @override
  Widget build(BuildContext context) {
    final box = Hive.box("expenses_tracker"); // Replace 'myData' with your box name

    // Check if data is present in the box
    final bool isDataPresent = box.isNotEmpty;

    return MaterialApp(
      home: isDataPresent ? const Dashboard() : UserDataEntryPage(),
    );
  }
}
