// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../constant.dart';

class Account {
  List AccountsList = [];
  List AccountsListss = [
    {
      "accountName": 'Esewa',
      "amount": "00000",
    },
  ];
  final _account = Hive.box("expenses_tracker");
  void getAccountDB() {
    AccountsList = _account.get("Account") ?? [];
    print(AccountsList);
  }

  void updateAccountDb() {
    _account.put("Account", AccountsListss);
    print("updated account");
  }
}

List AccountsList = [
  {
    "accountName": 'Esewa',
    "amount": "00000",
  },
  {
    "accountName": 'Khalti',
    "amount": "00000",
  },
  {
    "accountName": 'Bank',
    "amount": "00000",
  },
  {
    "accountName": 'Esewasssssssssss',
    "amount": "00000",
  },
];
