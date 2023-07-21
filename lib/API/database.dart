// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

class Database {
  List AccountsList = [];
  Map amountsList = {};
  List TransactionList = [];

  final _account = Hive.box("expenses_tracker");

  void getAccountDB() {
    AccountsList = _account.get("Account") ?? [];
    print(AccountsList);
  }

  void getAmountDB() {
    amountsList = _account.get("AmountList") ??
        {
          "currentBalance": 00000,
          "totalIncome": 00000,
          "totalExpenses": 00000,
          "toReceive": 00000,
          "toPay": 00000,
        };
  }

  void getTransactionDB() {
    TransactionList = _account.get("Transaction") ?? [];
    print(TransactionList);
  }

  void deleteAccountDB() {
    _account.delete("Account");
  }

  void deleteAmountDB() {
    _account.delete("AmountList");
  }

  void deleteTransaction() {
    _account.delete("Transaction");
  }

  void addAccountDB({accountName, amount}) {
    List inputAccount = [
      {
        "accountName": accountName ?? "",
        "amount": amount ?? 0,
      },
    ];
    getAccountDB();
    AccountsList = AccountsList + inputAccount;
    _account.put("Account", AccountsList);
    getAmountDB();
    amountsList['currentBalance'] = amount == null
        ? amountsList['currentBalance']
        : amountsList['currentBalance'] + amount;
    _account.put("AmountList", amountsList);
    List inputedTransactionLists = [
      {
        "Category": incomeT,
        "transationName": accountName,
        "transactionTag": "Account",
        "transactionDescription": "$accountName account added ",
        "transactionTags": accountName,
        "iconsName": " ",
        "toFromName": "Self",
        "Amount": amount,
        "transactionDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "transactionNote": "$accountName account added",
      },
    ];
    getTransactionDB();
    TransactionList = TransactionList + inputedTransactionLists;
    _account.put("Transaction", TransactionList);
    print("updated accountss");
  }

  void addTransactionDb(
      {transactionTitle,
      createdDate,
      amount,
      transactionType,
      transactionTag,
      transactionDate,
      transactionPerson,
      transactionNote,
      account}) {
    List inputedTransactionLists = [
      {
        "createdDate": createdDate ?? "",
        "Category": transactionType ?? "",
        "transationName": transactionTitle ?? "",
        "transactionTag": transactionTag ?? "",
        "transactionDescription": transactionNote ?? "",
        "transactionTags": transactionTag ?? "",
        "iconsName": transactionTag ?? "",
        "toFromName": transactionPerson ?? "",
        "Amount": amount ?? 0,
        "transactionDate": transactionDate ?? "",
        "transactionNote": transactionNote ?? "",
        "account": account ?? "",
      },
    ];
    getTransactionDB();
    TransactionList = TransactionList + inputedTransactionLists;
    _account.put("Transaction", TransactionList);
    getAmountDB();
    int Amount = amount;
    switch (transactionType) {
      case incomeT:
        amountsList['totalIncome'] = amount == null
            ? amountsList['totalIncome']
            : amountsList['totalIncome'] + Amount;
        amountsList['currentBalance'] = amount == null
            ? amountsList['currentBalance']
            : amountsList['currentBalance'] + Amount;

        break;

      case expensesT:
        amountsList['totalExpenses'] = amount == null
            ? amountsList['totalExpenses']
            : amountsList['totalExpenses'] + Amount;
        print(amountsList['currentBalance']);
        amountsList['currentBalance'] = amount == null
            ? amountsList['currentBalance']
            : amountsList['currentBalance'] - Amount;
        print(amountsList['currentBalance']);
        break;

      case toPayT:
        amountsList['toPay'] == null
            ? amountsList['toPay']
            : amountsList['toPay'] + Amount;
        break;
      case toReceiveT:
        amountsList['toReceive'] == null
            ? amountsList['toReceivee']
            : amountsList['toReceivee'] + Amount;
        break;
    }
    _account.put("AmountList", amountsList);
    print("updated transaction");
  }

  editTransaction({
    updated_transactionTitle,
    updated_amount,
    updated_transactionType,
    updated_transactionTag,
    updated_transactionDate,
    updated_transactionPerson,
    updated_transactionNote,
    updated_account,
    createdDate,
  }) {
    getTransactionDB();
    final index = TransactionList.indexWhere(
        (element) => element["createdDate"] == createdDate);
    print(index);
  }
}











  // void updateTransactionDb() {
  //   // TransactionList = TransactionList + TransactionListss;
  //   _account.put("Transaction", TransactionList);
  //   print("updated transaction");
  // }

 // List TransactionListss = [
  //   {
  //     "Category": incomeT,
  //     "transationName": 'Transaction Name dsvdvsdvsvs',
  //     "transactionTag": 'Tag',
  //     "transactionDescription": 'Transaction description',
  //     "transactionTags": ["Income", "Esewa"],
  //     "iconsName": Icons.shopping_cart_outlined,
  //     "toFromName": 'XYZ1',
  //     "Amount": "Rs 00000",
  //     "transactionDate": "0000-00-00",
  //     "transactionNote":
  //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam pulvinar elit in eros consequat, vitae porta tellus lobortis. Nulla laoreet id orci ac aliquam.4"
  //   },
  // ];



  // Map<String, int> amountsLists = {
  //   "currentBalance": 30000,
  //   "totalIncome": 20000,
  //   "totalExpenses": 00000,
  //   "toReceive": 00000,
  //   "toPay": 00000,
  // };

  // List AccountsListss = [
  //   {
  //     "accountName": 'Esewaa',
  //     "amount": 00000,
  //   },
  // ];




  // void updateAccountDb() {
  //   AccountsList = AccountsList + AccountsListss;
  //   _account.put("Account", AccountsList);
  //   print("updated accountss");
  // }




  //   print(amountsList);
  // }

// void updateAmountDb() {
//     // _account.delete("AmountList");
//     amountsList = amountsLists;
//     _account.put("AmountList", amountsLists);
//     print("updated ammount");
//   }
