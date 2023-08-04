// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expenses_tracker/Componet/logo_viewer.dart';
import 'package:expenses_tracker/Componet/menu_clicked_action.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

import '../constant.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buildDrawerOption(
      String title,
      IconData icons,
    ) {
      return ListTile(
        leading: Icon(icons),
        title: Text(title),
        onTap: () {
          // onTap;
          // Handle the onTap event for each option here
          // For example, you can use Navigator to navigate to a new screen.
          Navigator.pop(context); // Close the drawer after an option is selected
        },
      );
    }

    return SafeArea(
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: kMainBoxBorderColor,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kBoxShadowMainBoxBolor,
                      offset: Offset(4, 4),
                      blurRadius: 8,
                    ),
                  ],
                  // image: DecorationImage(image: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif')),
                  image: DecorationImage(image: AssetImage("assets/Logo/png/logo-white.png"), fit: BoxFit.fill),
                ),
                child: Container(
                  width: 0,
                )),
            CustomListTile(
              icons: Icons.cloud_done_outlined,
              label: 'Upload to cloud',
              onTap: () {
                handleMenuItemClick('Upload to cloud', context);
              },
            ),
            CustomListTile(
              icons: Icons.downloading_sharp,
              label: 'Retrive from cloud',
              onTap: () {
                handleMenuItemClick('Retrive from cloud', context);
              },
            ),
            CustomListTile(
              icons: Icons.update,
              label: 'Update DataBase',
              onTap: () {
                handleMenuItemClick('Update DataBase', context);
              },
            ),
            CustomListTile(
              icons: Icons.delete_forever_outlined,
              label: 'Delete DataBase',
              onTap: () {
                handleMenuItemClick('Delete DataBase', context);
              },
            ),
            CustomListTile(
              icons: Icons.logout_outlined,
              label: 'Logout',
              onTap: () {
                handleMenuItemClick('Logout', context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(
                thickness: 2,
                color: Color.fromARGB(255, 135, 135, 135),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icons;
  final String label;
  final Function()? onTap;
  const CustomListTile({
    super.key,
    required this.icons,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            thickness: 2,
            color: Color.fromARGB(255, 135, 135, 135),
          ),
        ),
        ListTile(
            leading: Icon(icons),
            title: Text(
              label,
              style: kwhiteTextStyle.copyWith(fontSize: 17),
            ),
            onTap: onTap),
      ],
    );
  }
}
