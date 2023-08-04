// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

class Database {
  List AccountsList = [];
  Map amountsList = {};
  List TransactionList = [];
  Map userDetail = {};
  final _account = Hive.box("expenses_tracker");

  void accountInitialized() {
    getAccountDB();
    if (AccountsList.isEmpty) {
      addAccountDB(
        accountName: miscellaneousaccountNameD,
        amount: 0,
      );
    }
  }

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
    TransactionList.sort((a, b) => a[transactionCreatedDateD].compareTo(b[transactionCreatedDateD]));
    print(TransactionList);
  }

  List getAccountNameListDB() {
    getAccountDB();
    List AccountNameList = [];
    for (int i = 0; i < AccountsList.length; i++) {
      AccountNameList.add(AccountsList[i][accountNameD]);
    }
    print(AccountNameList);
    return AccountNameList;
  }

  void getUserDetailDB() {
    userDetail =
        _account.get(userDataDatabase) ?? {userNameD: "User", userPhoneD: "9800000000", userEmailD: "xyz@example.com", userDOBD: "0000-00-00"};
    print(userDetail);
  }

  void deleteAccountDB() {
    _account.delete(accountDatabase);
  }

  void deleteAmountDB() {
    _account.delete(amountListDatabase);
  }

  void deleteTransactionDB() {
    _account.delete(transactionDatabase);
    print("Transaction database deleted");
  }

  void deleteUserDetailDB() {
    _account.delete(userDataDatabase);
  }

  void deleteAll() {
    deleteAccountDB();
    deleteAmountDB();
    // deleteUserNameDB();
    deleteTransactionDB();
    accountInitialized();
  }

  bool addAccountDB({accountName, amount}) {
    List inputAccount = [
      {
        accountNameD: accountName ?? "",
        accountCurrentBalanceD: amount ?? 0,
      },
    ];
    getAccountDB();
    bool isAccountNamePresent = AccountsList.where((account) => account[accountNameD] == accountName).isNotEmpty;
    if (!isAccountNamePresent) {
      AccountsList = AccountsList + inputAccount;
      _account.put(accountDatabase, AccountsList);
      getAmountDB();
      amountsList[totalIncomeD] = amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] + amount;
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
      return true;
    } else {
      return false;
    }
  }

  bool addAccountOnlyDB({accountName, amount}) {
    List inputAccount = [
      {
        accountNameD: accountName ?? "",
        accountCurrentBalanceD: amount ?? 0,
      },
    ];
    getAccountDB();
    bool isAccountNamePresent = AccountsList.where((account) => account[accountNameD] == accountName).isNotEmpty;
    if (!isAccountNamePresent) {
      AccountsList = AccountsList + inputAccount;
      _account.put(accountDatabase, AccountsList);
      print("updated accountss only");
      return true;
    } else {
      return false;
    }
  }

  void addTransactionDB(
      {transactionTitle, createdDate, amount, transactionType, transactionTag, transactionDate, transactionPerson, transactionNote, account}) {
    List inputedTransactionLists = [
      {
        transationNameD: transactionTitle ?? "",
        transactionAmountD: amount ?? 0,
        transactionTypeD: transactionType ?? "",
        transactionTagD: transactionTag ?? "",
        transactionDateD: transactionDate ?? "",
        transactionAccountD: account ?? miscellaneousaccountNameD,
        transactionPersonD: transactionPerson ?? "",
        transactionDescriptionD: transactionNote ?? "",
        transactionCreatedDateD: createdDate ?? "",
        transactionIconD: transactionTag ?? "",
        // "transactionNote": transactionNote ?? "",// transactionTagD: transactionTag ?? "",
      },
    ];
    if (!TransactionList.contains(inputedTransactionLists)) {
      getTransactionDB();
      TransactionList = TransactionList + inputedTransactionLists;
      _account.put(transactionDatabase, TransactionList);
      getAmountDB();
      getAccountDB();
      int Amount = amount ?? 0;
      var index = AccountsList.indexWhere((element) => element[accountNameD] == account);
      index = index != -1 ? index : 0;

      switch (transactionType) {
        case incomeT:
          amountsList[totalIncomeD] = amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] + Amount;
          amountsList[currentBalanceD] = amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + Amount;

          //for accounts
          AccountsList[index][accountCurrentBalanceD] = AccountsList[index][accountCurrentBalanceD] + Amount;
          break;

        case expensesT:
          amountsList[totalExpensesD] = amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] + Amount;
          print(amountsList[currentBalanceD]);
          amountsList[currentBalanceD] = amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - Amount;
          print(amountsList[currentBalanceD]);
          AccountsList[index][accountCurrentBalanceD] = AccountsList[index][accountCurrentBalanceD] - Amount;
          break;

        case toPayT:
          amountsList[toPayD] = amount == null ? amountsList[toPayD] : amountsList[toPayD] + Amount;
          break;
        case toReceiveT:
          amountsList[toReceiveD] = amount == null ? amountsList[toReceiveD] : amountsList[toReceiveD] + Amount;
          break;
      }
      _account.put(accountDatabase, AccountsList);
      _account.put(amountListDatabase, amountsList);
      print("updated transaction");
    }
  }

  void addUserDB({userName, userEmail, userPhoneNumber, userDOB}) {
    Map inputUser = {
      userNameD: userName ?? "",
      userPhoneD: userPhoneNumber ?? "",
      userEmailD: userEmail ?? "",
      userDOBD: userDOB ?? "",
    };
    _account.put(userDataDatabase, inputUser);
  }

  void editTransactionDB({
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
    };

    if (index != -1) {
      getAmountDB();
      getAccountDB();
      var accountIndex = AccountsList.indexWhere((element) => element[accountNameD] == updated_account);
      accountIndex = accountIndex != -1 ? accountIndex : 0;

      int? prevAmount = TransactionList[index][transactionAmountD];
      int Amount = int.tryParse(updated_amount) ?? 0;

      if (TransactionList[index][transactionAmountD] != Amount) {
        int amountChange = Amount - (prevAmount ?? 0);
        switch (updated_transactionType) {
          case incomeT:
            amountsList[totalIncomeD] += amountChange;
            amountsList[currentBalanceD] += amountChange;
            AccountsList[accountIndex][accountCurrentBalanceD] += amountChange;
            break;
          case expensesT:
            amountsList[totalExpensesD] += amountChange;
            amountsList[currentBalanceD] -= amountChange;
            AccountsList[accountIndex][accountCurrentBalanceD] -= amountChange;
            break;
          case toPayT:
            amountsList[toPayD] ??= 0;
            amountsList[toPayD] += amountChange;
            break;
          case toReceiveT:
            amountsList[toReceiveD] ??= 0;
            amountsList[toReceiveD] += amountChange;
            break;
        }
      }

      if (TransactionList[index][transactionTypeD] != updated_transactionType) {
        switch (updated_transactionType) {
          case incomeT:
            amountsList[totalIncomeD] += prevAmount ?? 0;
            switch (TransactionList[index][transactionTypeD]) {
              case expensesT:
                amountsList[totalExpensesD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] += prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] += prevAmount ?? 0;
                break;
              case toPayT:
                amountsList[toPayD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] += prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] += prevAmount ?? 0;
                break;
              case toReceiveT:
                amountsList[toReceiveD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] += prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] += prevAmount ?? 0;
                break;
            }
            break;
          case expensesT:
            amountsList[totalExpensesD] += prevAmount ?? 0;
            switch (TransactionList[index][transactionTypeD]) {
              case incomeT:
                amountsList[totalIncomeD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] -= (prevAmount ?? 0) * 2;
                AccountsList[accountIndex][accountCurrentBalanceD] -= (prevAmount ?? 0) * 2;
                break;
              case toPayT:
                amountsList[toPayD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] -= prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] -= prevAmount ?? 0;
                break;
              case toReceiveT:
                amountsList[toReceiveD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] -= prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] -= prevAmount ?? 0;
                break;
            }
            break;
          case toPayT:
            amountsList[toPayD] ??= 0;
            amountsList[toPayD] += prevAmount ?? 0;
            switch (TransactionList[index][transactionTypeD]) {
              case expensesT:
                amountsList[totalExpensesD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] += prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] += prevAmount ?? 0;
                break;
              case incomeT:
                amountsList[totalIncomeD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] -= prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] -= prevAmount ?? 0;
                break;
              case toReceiveT:
                amountsList[toReceiveD] -= prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] -= prevAmount ?? 0;
                break;
            }
            break;
          case toReceiveT:
            amountsList[toReceiveD] ??= 0;
            amountsList[toReceiveD] += prevAmount ?? 0;
            switch (TransactionList[index][transactionTypeD]) {
              case expensesT:
                amountsList[totalExpensesD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] += prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] += prevAmount ?? 0;
                break;
              case incomeT:
                amountsList[totalIncomeD] -= prevAmount ?? 0;
                amountsList[currentBalanceD] -= prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] -= prevAmount ?? 0;
                break;
              case toPayT:
                amountsList[toPayD] -= prevAmount ?? 0;
                AccountsList[accountIndex][accountCurrentBalanceD] -= prevAmount ?? 0;
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

  bool editAccountDB({accountName, amount, updated_accountName, updated_amount}) {
    print(accountName + amount + updated_accountName + updated_amount);
    getAccountDB();
    bool isSameAccount = accountName == updated_accountName;
    bool isAccountNamePresent = AccountsList.where((account) => account[accountNameD] == updated_accountName).isNotEmpty;

    if (!isAccountNamePresent || isSameAccount) {
      final index =
          AccountsList.indexWhere((element) => element[accountNameD] == accountName && element[accountCurrentBalanceD].toString() == amount);
      print(index);
      AccountsList[index][accountNameD] = updated_accountName;
      AccountsList[index][accountCurrentBalanceD] = updated_amount;
      getAmountDB();
      getAmountDB();
      amountsList[totalIncomeD] =
          updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] - int.tryParse(amount) + int.parse(updated_amount);
      amountsList[currentBalanceD] =
          updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - int.tryParse(amount) + int.parse(updated_amount);
      _account.put(amountListDatabase, amountsList);
      _account.put(accountDatabase, AccountsList);
      return true;
    } else {
      return false;
    }
  }

  void editUserNameDB({updated_userName, updated_userEmail, updated_userPhoneNumber, updated_userDOB}) {
    getUserDetailDB();
    Map updated_inputUser = {
      userNameD: updated_userName ?? "",
      userPhoneD: updated_userPhoneNumber ?? "",
      userEmailD: updated_userEmail ?? "",
      userDOBD: updated_userDOB ?? "",
    };
    userDetail = updated_inputUser;
    _account.put(userDataDatabase, userDetail);
  }

  void editAmountDB({updated_CurrentBalance, updated_TotalIncome, updated_totalExpenses, updated_TotalToPay, updated_TotalToReceive}) {
    getAmountDB();
    Map updated_inputAmount = {
      currentBalanceD: updated_CurrentBalance ?? 0,
      totalIncomeD: updated_TotalIncome ?? 0,
      totalExpensesD: updated_totalExpenses ?? 0,
      toReceiveD: updated_TotalToReceive ?? 0,
      toPayD: updated_TotalToPay ?? 0,
    };
    amountsList = updated_inputAmount;
    _account.put(amountListDatabase, amountsList);
  }

  void onCompletedClicked({
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
    editTransactionDB(
      updated_transactionTitle: TransactionList[index][transationNameD],
      updated_amount: TransactionList[index][transactionAmountD].toString(),
      updated_transactionType: TransactionList[index][transactionTypeD] == toPayT ? expensesT : incomeT,
      updated_transactionTag: TransactionList[index][transactionTagD],
      updated_transactionDate: TransactionList[index][transactionDateD],
      updated_transactionPerson: TransactionList[index][transactionPersonD],
      updated_transactionNote: TransactionList[index][updated_transactionNote],
      updated_account: TransactionList[index][transactionAccountD],
      createdDate: TransactionList[index][transactionCreatedDateD],
    );
  }
}



//  void editTransactionDB({
//     updated_transactionTitle,
//     updated_amount,
//     updated_transactionType,
//     updated_transactionTag,
//     updated_transactionDate,
//     updated_transactionPerson,
//     updated_transactionNote,
//     updated_account,
//     createdDate,
//   }) {
//     getTransactionDB();
//     final index = TransactionList.indexWhere((element) => element[transactionCreatedDateD] == createdDate);
//     print(index);
//     Map updatedTransactionLists = {
//       transationNameD: updated_transactionTitle ?? "",
//       transactionAmountD: int.tryParse(updated_amount) ?? 0,
//       transactionTypeD: updated_transactionType ?? "",
//       transactionTagD: updated_transactionTag ?? "",
//       transactionDateD: updated_transactionDate ?? "",
//       transactionAccountD: updated_account ?? "",
//       transactionPersonD: updated_transactionPerson ?? "",
//       transactionDescriptionD: updated_transactionNote ?? "",
//       transactionCreatedDateD: createdDate ?? "",
//       transactionIconD: updated_transactionTag ?? "",
//       // "transactionNote": updated_transactionNote ?? "",  // "transactionTags": updated_transactionTag ?? "",
//     };

//     if (index != -1) {
//       getAmountDB();
//       getAccountDB();
//       var accountIndex = AccountsList.indexWhere((element) => element[accountNameD] == updated_account);
//       accountIndex = accountIndex != -1 ? accountIndex : 0;
//       //amount is changed from PreAmount to updated ammoun
//       if (TransactionList[index][transactionAmountD] != updated_amount) {
//         int? prevAmount = TransactionList[index][transactionAmountD];
//         //calculate amount change from previous amount to updated amount
//         int Amount = int.tryParse(updated_amount)! - prevAmount!;

//         switch (updated_transactionType) {
//           //initiate transaction was income
//           case incomeT:
//             amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] + Amount;
//             amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + Amount;

//             //Accounts updation
//             AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] + Amount;
//             break;

//           //initiate transaction was expense
//           case expensesT:
//             amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] + Amount;
//             print(amountsList[currentBalanceD]);
//             amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - Amount;
//             print(amountsList[currentBalanceD]);

//             //Accounts updation
//             AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] - Amount;
//             break;
//           //initiate transaction was toPay
//           case toPayT:
//             amountsList[toPayD] == null ? amountsList[toPayD] : amountsList[toPayD] + Amount;
//             break;

//           //initiate transaction was toreceive
//           case toReceiveT:
//             amountsList[toReceiveD] == null ? amountsList[toReceiveD] : amountsList[toReceiveD] + Amount;
//             break;
//         }
//       }

//       //transaction type wa changer
//       if (TransactionList[index][transactionTypeD] != updated_transactionType) {
//         int? prevAmount = TransactionList[index][transactionAmountD];
//         switch (updated_transactionType) {
//           //updated transaction is income
//           case incomeT:
//             amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] + prevAmount;
//             switch (TransactionList[index][transactionTypeD]) {
//               //expensens to income
//               case expensesT:
//                 amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] - prevAmount;
//                 amountsList[currentBalanceD] =
//                     updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount + prevAmount;

//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] + prevAmount + prevAmount;
//                 break;
//               //topay to income
//               case toPayT:
//                 amountsList[toPayD] = updated_amount == null ? amountsList[toPayD] : amountsList[toPayD] - prevAmount;
//                 amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] + prevAmount;
//                 break;
//               //torecive to income
//               case toReceiveT:
//                 amountsList[toReceiveD] = updated_amount == null ? amountsList[toReceiveD] : amountsList[toReceiveD] - prevAmount;
//                 amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] + prevAmount;
//                 break;
//             }
//             break;
//           //updated transaction was expenses
//           case expensesT:
//             amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] + prevAmount;
//             switch (TransactionList[index][transactionTypeD]) {
//               //income to expenses
//               case incomeT:
//                 amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] - prevAmount;
//                 amountsList[currentBalanceD] =
//                     updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount - prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] - prevAmount - prevAmount;
//                 break;
//               //topay to expenses
//               case toPayT:
//                 amountsList[toPayD] = updated_amount == null ? amountsList[toPayD] : amountsList[toPayD] - prevAmount;
//                 amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] - prevAmount;
//                 break;
//               //torecive to expenses
//               case toReceiveT:
//                 amountsList[toReceiveD] = updated_amount == null ? amountsList[toReceiveD] : amountsList[toReceiveD] - prevAmount;
//                 amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] - prevAmount;
//                 break;
//             }
//             break;
//           //updated transaction was to pay
//           case toPayT:
//             amountsList[toPayD] = updated_amount == null ? amountsList[toPayD] : amountsList[toPayD] + prevAmount;
//             switch (TransactionList[index][transactionTypeD]) {
//               //expensens to  To Pay
//               case expensesT:
//                 amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] - prevAmount;
//                 amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] + prevAmount;
//                 break;
//               //income to  To Pay
//               case incomeT:
//                 amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] - prevAmount;
//                 amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] - prevAmount;
//                 break;
//               //torecive to To Pay
//               case toReceiveT:
//                 amountsList[toReceiveD] = updated_amount == null ? amountsList[toReceiveD] : amountsList[toReceiveD] - prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] - prevAmount;
//                 break;
//             }
//             break;
//           //update transaction is toreceived
//           case toReceiveT:
//             amountsList[toReceiveD] = updated_amount == null ? amountsList[toReceiveD] : amountsList[toReceiveD] + prevAmount;
//             switch (TransactionList[index][transactionTypeD]) {
//               //expensens to toReceive
//               case expensesT:
//                 amountsList[totalExpensesD] = updated_amount == null ? amountsList[totalExpensesD] : amountsList[totalExpensesD] - prevAmount;
//                 amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] + prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] + prevAmount;
//                 break;
//               //income to toReceive
//               case incomeT:
//                 amountsList[totalIncomeD] = updated_amount == null ? amountsList[totalIncomeD] : amountsList[totalIncomeD] - prevAmount;
//                 amountsList[currentBalanceD] = updated_amount == null ? amountsList[currentBalanceD] : amountsList[currentBalanceD] - prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] - prevAmount;
//                 break;
//               //topay to toReceive
//               case toPayT:
//                 amountsList[toPayD] = updated_amount == null ? amountsList[toPayD] : amountsList[toPayD] - prevAmount;
//                 //Account updation
//                 AccountsList[accountIndex][accountCurrentBalanceD] = AccountsList[accountIndex][accountCurrentBalanceD] - prevAmount;
//                 break;
//             }
//             break;
//         }
//       }
//     }
//     TransactionList[index] = updatedTransactionLists;
//     _account.put(transactionDatabase, TransactionList);
//     _account.put(amountListDatabase, amountsList);
//   }








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
