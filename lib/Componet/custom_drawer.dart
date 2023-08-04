import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buildDrawerOption(String title, IconData icons) {
      return ListTile(
        leading: Icon(icons),
        title: Text(title),
        onTap: () {
          // Handle the onTap event for each option here
          // For example, you can use Navigator to navigate to a new screen.
          Navigator.pop(context); // Close the drawer after an option is selected
        },
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Image.asset('assets/logo.png'),
          ),
          buildDrawerOption('Option 1', Icons.delete),
          buildDrawerOption('Option 1', Icons.delete),
          buildDrawerOption('Option 1', Icons.delete),
          buildDrawerOption('Option 1', Icons.delete),
          buildDrawerOption('Option 1', Icons.delete),

          // Add more options as needed
        ],
      ),
    );
  }
}
