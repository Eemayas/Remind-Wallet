// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';

class Database {
  List AccountsList = [];
  Map amountsList = {};
  List TransactionDetailsList = [];

  Map<String, String> amountsLists = {
    "currentBalance": "30,000",
    "totalIncome": "20,000",
    "totalExpenses": "00,000",
    "toReceive": "00,000",
    "toPay": "00,000",
  };

  List AccountsListss = [
    {
      "accountName": 'Esewaa',
      "amount": "00000",
    },
  ];

  final _account = Hive.box("expenses_tracker");

  void getAccountDB() {
    AccountsList = _account.get("Account") ?? [];
    print(AccountsList);
  }

  void updateAccountDb() {
    AccountsList = AccountsList + AccountsListss;
    _account.put("Account", AccountsList);
    print("updated accountss");
  }

  void getAmountDB() {
    amountsList = _account.get("AmountList") ??
        {
          "currentBalance": "00,000",
          "totalIncome": "00,000",
          "totalExpenses": "00,000",
          "toReceive": "00,000",
          "toPay": "00,000",
        };

    print(amountsList);
  }

  void updateAmountDb() {
    // _account.delete("AmountList");
    amountsList = amountsLists;
    _account.put("AmountList", amountsLists);
    print("updated ammount");
  }
}
