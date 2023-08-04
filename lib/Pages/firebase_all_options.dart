// ignore_for_file: must_be_immutable, prefer_const_constructors, camel_case_types

import 'package:expenses_tracker/API/firebase_databse.dart';
import 'package:expenses_tracker/Componet/custom_button.dart';
import 'package:flutter/material.dart';

class FirebaseAllOptions extends StatelessWidget {
  static String id = "sfsdsd";
  FirebaseAllOptions({super.key});
  FirebaseDatabases fd = FirebaseDatabases();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomProgressButton(
                  label: "Account Save",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.saveAccountsToFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "Transaction Save",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.saveTransactionDataToFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "User Data Save",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.saveUserDetailToFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "Amount Save",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.saveAmountsToFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "All Save",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.saveAllDataToFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "Account Receive",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.retrieveAccountsFromFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "Transaction Receive",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.retrieveTransactionsFromFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "User Data Receive",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.retrieveUserDetailFromFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "Amount Receive",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.retrieveAmountsFromFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "All Receive",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.retrieveAllDataFromFirebase(context);
                  }),
              zzzhhhh(),
              CustomProgressButton(
                  label: "All Detete",
                  icons: Icons.save_alt_outlined,
                  onTap: () {
                    fd.deleteAllDataFromFirestore(context);
                  }),
            ],
          ),
        ),
      )),
    );
  }
}

class zzzhhhh extends StatelessWidget {
  const zzzhhhh({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
    );
  }
}
