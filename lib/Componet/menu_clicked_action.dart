// ignore_for_file: use_build_context_synchronously

import 'package:expenses_tracker/API/database.dart';
import 'package:expenses_tracker/API/firebase_databse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/provider.dart';
import 'custom_alert_dialog.dart';
import 'custom_snackbar.dart';

Database db = Database();
FirebaseDatabases fd = FirebaseDatabases();
Future<void> handleMenuItemClick(String value, BuildContext context) async {
  // Implement the logic for each option here
  switch (value) {
    case 'Delete DataBase':
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(
                title: 'Warning: Database Deletion',
                titleTextColor: Colors.red,
                confirmTextColor: Colors.red,
                message: 'Are you sure you want to delete the database? This action cannot be undone.',
                onConfirm: () {
                  db.deleteAll();
                  Navigator.pop(context);
                  customSnackbar(
                    context: context,
                    text: 'Database Deleted',
                    icons: Icons.delete_forever,
                  );
                  // List tryyy = db.TransactionList;
                  db.getAccountDB();
                  db.getAmountDB();
                  db.getTransactionDB();
                  // tryyy = db.TransactionList;
                  context.read<ChangedMsg>().changed();
                });
          });
      break;
    case 'Update DataBase':
      db.getAccountDB();
      db.getAmountDB();
      db.getTransactionDB();
      context.read<ChangedMsg>().changed();
      customSnackbar(context: context, text: 'Database Refresh', icons: Icons.done_all, iconsColor: Colors.green);
      break;
    case 'Options:':
      break;
    case 'Upload to cloud':
      // ignore: unused_local_variable
      Future<bool> isSucess = fd.saveAllDataToFirebase(context);

      break;
    case 'Retrive from cloud':
      // ignore: unused_local_variable
      Future<bool> isSucess = fd.retrieveAllDataFromFirebase(context);
      if (await isSucess) {
        customSnackbar(context: context, text: "All datas are received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
        db.getAccountDB();
        db.getAmountDB();
        db.getTransactionDB();
        context.read<ChangedMsg>().changed();
      }

      break;
    case 'Logout':
      // Future<bool> isSucess = fd.saveAllDataToFirebase(context);
      if (await fd.saveAllDataToFirebase(context)) {
        db.deleteAll();
        db.deleteUserDetailDB();
        await FirebaseAuth.instance.signOut();
        customSnackbar(context: context, text: 'Logout Sucessfully', icons: Icons.logout_rounded, iconsColor: Colors.green);
      } else {
        customSnackbar(
          context: context,
          text: 'Please Upload to Firebase First',
        );
      }
      break;
  }
}
