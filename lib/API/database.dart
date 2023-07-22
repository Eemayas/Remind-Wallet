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
    AccountsList = _account.get(accountDatabase) ?? [];
    print(AccountsList);
  }

  void getAmountDB() {
    amountsList = _account.get(amountListDatabase) ??
        {
          currentBalanceD: 00000,
          totalIncomeD: 00000,
          totalExpensesD: 00000,
          toReceiveD: 00000,
          toPayD: 00000,
        };
  }

  void getTransactionDB() {
    TransactionList = _account.get(transactionDatabase) ?? [];
    print(TransactionList);
  }

  void deleteAccountDB() {
    _account.delete(accountDatabase);
  }

  void deleteAmountDB() {
    _account.delete(amountListDatabase);
  }

  void deleteTransaction() {
    _account.delete(transactionDatabase);
  }

  void addAccountDB({accountName, amount}) {
    List inputAccount = [
      {
        accountNameD: accountName ?? "",
        accountCurrentBalanceD: amount ?? 0,
      },
    ];
    getAccountDB();
    AccountsList = AccountsList + inputAccount;
    _account.put(accountDatabase, AccountsList);
    getAmountDB();
    amountsList[currentBalanceD] = amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + amount;
    _account.put(amountListDatabase, amountsList);
    List inputedTransactionLists = [
      {
        transationNameD: accountName,
        transactionAmountD: amount,
        transactionTypeD: incomeT,
        transactionTagD: "Account",
        transactionDateD: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        transactionAccountD: accountName ?? "",
        transactionPersonD: "Self",
        transactionDescriptionD: "$accountName account added ",
        transactionIconD: " ",
        transactionCreatedDateD: DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now()),
        // "transactionNote": "$accountName account added",
      },
    ];
    getTransactionDB();
    TransactionList = TransactionList + inputedTransactionLists;
    _account.put(transactionDatabase, TransactionList);
    print("updated accountss");
  }

  void addTransactionDb(
      {transactionTitle, createdDate, amount, transactionType, transactionTag, transactionDate, transactionPerson, transactionNote, account}) {
    List inputedTransactionLists = [
      {
        transationNameD: transactionTitle ?? "",
        transactionAmountD: amount ?? 0,
        transactionTypeD: transactionType ?? "",
        transactionTagD: transactionTag ?? "",
        transactionDateD: transactionDate ?? "",
        transactionAccountD: account ?? "",
        transactionPersonD: transactionPerson ?? "",
        transactionDescriptionD: transactionNote ?? "",
        transactionCreatedDateD: createdDate ?? "",
        transactionIconD: transactionTag ?? "",
        // "transactionNote": transactionNote ?? "",// transactionTagD: transactionTag ?? "",
      },
    ];
    getTransactionDB();
    TransactionList = TransactionList + inputedTransactionLists;
    _account.put(transactionDatabase, TransactionList);
    getAmountDB();
    int Amount = amount;
    switch (transactionType) {
      case incomeT:
        amountsList[totalIncomeD] = amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] + Amount;
        amountsList[currentBalanceD] = amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + Amount;

        break;

      case expensesT:
        amountsList[totalExpensesD] = amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] + Amount;
        print(amountsList[currentBalanceD]);
        amountsList[currentBalanceD] = amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - Amount;
        print(amountsList[currentBalanceD]);
        break;

      case toPayT:
        amountsList[toPayD] == null ? amountsList[toPayD] : amountsList[toPayD] + Amount;
        break;
      case toReceiveT:
        amountsList[toReceiveD] == null ? amountsList[toReceiveD] : amountsList[toReceiveD] + Amount;
        break;
    }
    _account.put(amountListDatabase, amountsList);
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
    final index = TransactionList.indexWhere((element) => element[transactionCreatedDateD] == createdDate);
    print(index);
    Map updatedTransactionLists = {
      transationNameD: updated_transactionTitle ?? "",
      transactionAmountD: int.tryParse(updated_amount) ?? 0,
      transactionTypeD: updated_transactionType ?? "",
      transactionTagD: updated_transactionTag ?? "",
      transactionDateD: updated_transactionDate ?? "",
      transactionAccountD: updated_account ?? "",
      transactionPersonD: updated_transactionPerson ?? "",
      transactionDescriptionD: updated_transactionNote ?? "",
      transactionCreatedDateD: createdDate ?? "",
      transactionIconD: updated_transactionTag ?? "",
      // "transactionNote": updated_transactionNote ?? "",  // "transactionTags": updated_transactionTag ?? "",
    };

    if (index != -1) {
      getAmountDB();
      if (TransactionList[index][transactionAmountD] != updated_amount) {
        int? prevAmount = TransactionList[index][transactionAmountD];
        int Amount = int.tryParse(updated_amount)! - prevAmount!;
        switch (updated_transactionType) {
          case incomeT:
            amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] + Amount;
            amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + Amount;

            break;

          case expensesT:
            amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] + Amount;
            print(amountsList[currentBalanceD]);
            amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - Amount;
            print(amountsList[currentBalanceD]);
            break;

          case toPayT:
            amountsList[toPayD] == null ? amountsList[toPayD] : amountsList[toPayD] + Amount;
            break;
          case toReceiveT:
            amountsList[toReceiveD] == null ? amountsList[toReceiveD] : amountsList[toReceiveD] + Amount;
            break;
        }
      }
      if (TransactionList[index][transactionTypeD] != updated_transactionType) {
        int? prevAmount = TransactionList[index][transactionAmountD];
        switch (updated_transactionType) {
          case incomeT:
            amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] + prevAmount;
            switch (TransactionList[index][transactionTypeD]) {
              case expensesT:
                amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] - prevAmount;
                amountsList[currentBalanceD] =
                    updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount + prevAmount;
                break;
              case toPayT:
                amountsList[toPayD] = updated_amount == null ? amountsList[toPayD] : amountsList[toPayD] - prevAmount;
                amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount;
                break;
              case toReceiveT:
                amountsList[toReceiveD] = updated_amount == null ? amountsList[toReceiveD] : amountsList[toReceiveD] - prevAmount;
                amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount;
                break;
            }
            break;
          case expensesT:
            amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] + prevAmount;
            switch (TransactionList[index][transactionTypeD]) {
              case incomeT:
                amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] - prevAmount;
                amountsList[currentBalanceD] =
                    updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount - prevAmount;
                break;
              case toPayT:
                amountsList[toPayD] = updated_amount == null ? amountsList[toPayD] : amountsList[toPayD] - prevAmount;
                amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount;
                break;
              case toReceiveT:
                amountsList[toReceiveD] = updated_amount == null ? amountsList[toReceiveD] : amountsList[toReceiveD] - prevAmount;
                amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount;
                break;
            }
            break;
          case toPayT:
            amountsList[toPayD] = updated_amount == null ? amountsList[toPayD] : amountsList[toPayD] + prevAmount;
            switch (TransactionList[index][transactionTypeD]) {
              case expensesT:
                amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] - prevAmount;
                amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount;
                break;
              case incomeT:
                amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] - prevAmount;
                amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount;
                break;
              case toReceiveT:
                amountsList[toReceiveD] = updated_amount == null ? amountsList[toReceiveD] : amountsList[toReceiveD] - prevAmount;
                break;
            }
            break;
          case toReceiveT:
            amountsList[toReceiveD] = updated_amount == null ? amountsList[toReceiveD] : amountsList[toReceiveD] + prevAmount;
            switch (TransactionList[index][transactionTypeD]) {
              case expensesT:
                amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] - prevAmount;
                amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount;
                break;
              case incomeT:
                amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] - prevAmount;
                amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount;
                break;
              case toPayT:
                amountsList[toPayD] = updated_amount == null ? amountsList[toPayD] : amountsList[toPayD] - prevAmount;
                break;
            }
            break;
        }
      }
    }
    TransactionList[index] = updatedTransactionLists;
    _account.put(transactionDatabase, TransactionList);
    _account.put(amountListDatabase, amountsList);
  }
}











  // void updateTransactionDb() {
  //   // TransactionList = TransactionList + TransactionListss;
  //   _account.put("Transaction", TransactionList);
  //   print("updated transaction");
  // }

 // List TransactionListss = [
  //   {
  //      transactionTypeD: incomeT,
  //     transationNameD: 'Transaction Name dsvdvsdvsvs',
  //     transactionTagD: 'Tag',
  //     transactionDescriptionD: 'Transaction description',
  //     "transactionTags": ["Income", "Esewa"],
  //     transactionIconD: Icons.shopping_cart_outlined,
  //     transactionPersonD: 'XYZ1',
  //     transactionAmountD: "Rs 00000",
  //     transactionDateD: "0000-00-00",
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
  //     transactionAmountD: 00000,
  //   },
  // ];




  // void updateAccountDb() {
  //   AccountsList = AccountsList + AccountsListss;
  //   _account.put(AccountDatabase, AccountsList);
  //   print("updated accountss");
  // }




  //   print(amountsList);
  // }

// void updateAmountDb() {
//     // _account.delete(AmountListDatabase);
//     amountsList = amountsLists;
//     _account.put(AmountListDatabase, amountsLists);
//     print("updated ammount");
//   }
