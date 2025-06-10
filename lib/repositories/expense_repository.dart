import 'package:hive/hive.dart';

import '../constant.dart';
import '../models/account_model.dart';
import '../models/amount_summary_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

abstract class ExpenseRepository {
  Future<List<Account>> getAccounts();
  Future<List<Transaction>> getTransactions();
  Future<AmountSummary> getAmountSummary();
  Future<User> getUserDetails();

  Future<void> addAccount(Account account);
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> updateUser(User user);
  Future<void> updateAmountSummary(AmountSummary summary);

  Future<void> deleteAllData();
  Future<void> recalculateBalances();
}

class HiveExpenseRepository implements ExpenseRepository {
  final Box _box = Hive.box("expenses_tracker");

  @override
  Future<List<Account>> getAccounts() async {
    try {
      final List<dynamic> accountsData = _box.get(accountDatabase) ?? [];
      return accountsData.map((data) => Account.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Failed to load accounts: $e');
    }
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    try {
      final List<dynamic> transactionsData =
          _box.get(transactionDatabase) ?? [];
      final transactions =
          transactionsData.map((data) => Transaction.fromJson(data)).toList();

      // Sort by created date
      transactions.sort((a, b) => a.createdDate.compareTo(b.createdDate));
      return transactions;
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  @override
  Future<AmountSummary> getAmountSummary() async {
    try {
      final Map<String, dynamic> summaryData =
          Map<String, dynamic>.from(_box.get(amountListDatabase) ?? {});
      return summaryData.isEmpty
          ? AmountSummary.empty
          : AmountSummary.fromJson(summaryData);
    } catch (e) {
      throw Exception('Failed to load amount summary: $e');
    }
  }

  @override
  Future<User> getUserDetails() async {
    try {
      final Map<String, dynamic> userData =
          Map<String, dynamic>.from(_box.get(userDataDatabase) ?? {});
      return userData.isEmpty ? User.empty : User.fromJson(userData);
    } catch (e) {
      throw Exception('Failed to load user details: $e');
    }
  }

  @override
  Future<void> addAccount(Account account) async {
    try {
      final accounts = await getAccounts();

      // Check if account already exists
      final exists = accounts.any((acc) => acc.name == account.name);
      if (exists) {
        throw Exception('Account with this name already exists');
      }

      accounts.add(account);
      await _box.put(
          accountDatabase, accounts.map((acc) => acc.toJson()).toList());

      // Update amount summary
      final summary = await getAmountSummary();
      final updatedSummary = summary.copyWith(
        totalIncome: summary.totalIncome + account.currentBalance,
        currentBalance: summary.currentBalance + account.currentBalance,
      );
      await updateAmountSummary(updatedSummary);
    } catch (e) {
      throw Exception('Failed to add account: $e');
    }
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    try {
      final transactions = await getTransactions();
      transactions.add(transaction);

      // Sort transactions by date
      transactions.sort((a, b) => a.createdDate.compareTo(b.createdDate));

      await _box.put(transactionDatabase,
          transactions.map((trans) => trans.toJson()).toList());

      // Update balances
      await _updateBalancesForTransaction(transaction, isAdd: true);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      final transactions = await getTransactions();
      final index = transactions
          .indexWhere((trans) => trans.createdDate == transaction.createdDate);

      if (index == -1) {
        throw Exception('Transaction not found');
      }

      final oldTransaction = transactions[index];
      transactions[index] = transaction;

      await _box.put(transactionDatabase,
          transactions.map((trans) => trans.toJson()).toList());

      // Update balances (remove old, add new)
      await _updateBalancesForTransaction(oldTransaction, isAdd: false);
      await _updateBalancesForTransaction(transaction, isAdd: true);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await _box.put(userDataDatabase, user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> updateAmountSummary(AmountSummary summary) async {
    try {
      await _box.put(amountListDatabase, summary.toJson());
    } catch (e) {
      throw Exception('Failed to update amount summary: $e');
    }
  }

  @override
  Future<void> deleteAllData() async {
    try {
      await _box.delete(accountDatabase);
      await _box.delete(transactionDatabase);
      await _box.delete(amountListDatabase);
      await _box.delete(userDataDatabase);

      // Initialize with default account
      await addAccount(const Account(
        name: miscellaneousaccountNameD,
        currentBalance: 0,
      ));
    } catch (e) {
      throw Exception('Failed to delete all data: $e');
    }
  }

  @override
  Future<void> recalculateBalances() async {
    try {
      final accounts = await getAccounts();
      final transactions = await getTransactions();

      // Reset all account balances
      final updatedAccounts = accounts
          .map((account) => account.copyWith(currentBalance: 0))
          .toList();

      int totalIncome = 0;
      int totalExpenses = 0;
      int toPay = 0;
      int toReceive = 0;

      // Recalculate based on transactions
      for (final transaction in transactions) {
        final accountIndex = updatedAccounts
            .indexWhere((acc) => acc.name == transaction.account);

        if (accountIndex != -1) {
          switch (transaction.type) {
            case TransactionType.income:
              totalIncome += transaction.amount;
              updatedAccounts[accountIndex] = updatedAccounts[accountIndex]
                  .copyWith(
                      currentBalance:
                          updatedAccounts[accountIndex].currentBalance +
                              transaction.amount);
              break;
            case TransactionType.expense:
              totalExpenses += transaction.amount;
              updatedAccounts[accountIndex] = updatedAccounts[accountIndex]
                  .copyWith(
                      currentBalance:
                          updatedAccounts[accountIndex].currentBalance -
                              transaction.amount);
              break;
            case TransactionType.toPay:
              toPay += transaction.amount;
              break;
            case TransactionType.toReceive:
              toReceive += transaction.amount;
              break;
          }
        }
      }

      // Save updated accounts
      await _box.put(
          accountDatabase, updatedAccounts.map((acc) => acc.toJson()).toList());

      // Update amount summary
      final summary = AmountSummary(
        currentBalance: totalIncome - totalExpenses,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        toPay: toPay,
        toReceive: toReceive,
      );
      await updateAmountSummary(summary);
    } catch (e) {
      throw Exception('Failed to recalculate balances: $e');
    }
  }

  Future<void> _updateBalancesForTransaction(Transaction transaction,
      {required bool isAdd}) async {
    final summary = await getAmountSummary();
    final accounts = await getAccounts();

    final accountIndex =
        accounts.indexWhere((acc) => acc.name == transaction.account);

    if (accountIndex == -1) return;

    final multiplier = isAdd ? 1 : -1;
    final amount = transaction.amount * multiplier;

    AmountSummary updatedSummary = summary;
    Account updatedAccount = accounts[accountIndex];

    switch (transaction.type) {
      case TransactionType.income:
        updatedSummary = summary.copyWith(
          totalIncome: summary.totalIncome + amount,
          currentBalance: summary.currentBalance + amount,
        );
        updatedAccount = updatedAccount.copyWith(
          currentBalance: updatedAccount.currentBalance + amount,
        );
        break;
      case TransactionType.expense:
        updatedSummary = summary.copyWith(
          totalExpenses: summary.totalExpenses + amount,
          currentBalance: summary.currentBalance - amount,
        );
        updatedAccount = updatedAccount.copyWith(
          currentBalance: updatedAccount.currentBalance - amount,
        );
        break;
      case TransactionType.toPay:
        updatedSummary = summary.copyWith(
          toPay: summary.toPay + amount,
        );
        break;
      case TransactionType.toReceive:
        updatedSummary = summary.copyWith(
          toReceive: summary.toReceive + amount,
        );
        break;
    }

    // Update account
    accounts[accountIndex] = updatedAccount;
    await _box.put(
        accountDatabase, accounts.map((acc) => acc.toJson()).toList());

    // Update summary
    await updateAmountSummary(updatedSummary);
  }
}
