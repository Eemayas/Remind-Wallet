import 'package:hive/hive.dart';
import 'package:remind_wallet/global/utils/generate_unique_id.dart';
import 'package:remind_wallet/utils/logger.dart';

import '../constant.dart';
import '../models/account_model.dart';
import '../models/amount_summary_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

abstract class ExpenseRepository {
  Future<List<AccountModel>> getAccounts();
  Future<List<Transaction>> getTransactions();
  Future<AmountSummary> getAmountSummary();
  Future<User> getUserDetails();

  Future<void> addAccount(AccountModel account);
  Future<void> updateAccount(AccountModel account);
  Future<void> deleteAccount(AccountModel account);
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> updateUser(User user);
  Future<void> updateAmountSummary(AmountSummary summary);

  Future<void> deleteAllData();
  Future<void> recalculateBalances();
}

class HiveExpenseRepository implements ExpenseRepository {
  final Box _box = Hive.box("expenses_tracker_new");
  static const String className = 'HiveExpenseRepository';

  @override
  Future<List<AccountModel>> getAccounts() async {
    const functionName = '$className.getAccounts';
    logStarting(
        functionName: functionName, message: 'Fetching accounts from Hive.');

    try {
      logProcessing(
          functionName: functionName, message: 'Reading data from box.');
      final List<dynamic> accountsData = _box.get(accountDatabase) ?? [];

      logOngoing(
          functionName: functionName,
          message: 'Mapping data to Account objects.');
      final accounts = accountsData
          .map((data) => AccountModel.fromJson(Map<String, dynamic>.from(data)))
          .toList();

      logSuccess(
          functionName: functionName,
          message: 'Successfully fetched ${accounts.length} accounts.');
      return accounts;
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while fetching accounts: $e',
          errorCode: null);
      throw Exception('Failed to load accounts: $e');
    }
  }

  @override
  Future<void> deleteAccount(AccountModel account) async {
    const functionName = '$className.deleteAccount';
    logStarting(
        functionName: functionName, message: 'Deleting account: ${account.id}');

    try {
      logProcessing(
          functionName: functionName, message: 'Fetching existing accounts.');
      final accounts = await getAccounts();

      logOngoing(
          functionName: functionName,
          message: 'Locating account by ID for deletion.');
      final index = accounts.indexWhere((acc) => acc.id == account.id);
      if (index == -1) {
        logFailure(
            functionName: functionName,
            message: 'Account not found for deletion.');
        throw Exception('Account not found');
      }

      accounts.removeAt(index);

      logProcessing(
          functionName: functionName,
          message: 'Saving updated account list to Hive.');
      await _box.put(
          accountDatabase, accounts.map((acc) => acc.toJson()).toList());

      logProcessing(
          functionName: functionName, message: 'Updating amount summary.');
      final summary = await getAmountSummary();
      final updatedSummary = summary.copyWith(
        totalIncome: summary.totalIncome - account.currentBalance,
        currentBalance: summary.currentBalance - account.currentBalance,
      );
      await updateAmountSummary(updatedSummary);

      logSuccess(
          functionName: functionName,
          message: 'Account "${account.name}" deleted successfully.');
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while deleting account: $e',
          errorCode: null);
      throw Exception('Failed to delete account: $e');
    }
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    const functionName = '$className.getTransactions';
    logStarting(
        functionName: functionName,
        message: 'Fetching transactions from Hive.');

    try {
      logProcessing(
          functionName: functionName, message: 'Reading data from box.');
      final List<dynamic> transactionsData =
          _box.get(transactionDatabase) ?? [];

      logOngoing(
          functionName: functionName,
          message: 'Mapping data to Transaction objects.');
      final transactions =
          transactionsData.map((data) => Transaction.fromJson(data)).toList();

      logProcessing(
          functionName: functionName,
          message: 'Sorting transactions by created date.');
      transactions.sort((a, b) => a.createdDate.compareTo(b.createdDate));

      logSuccess(
          functionName: functionName,
          message: 'Successfully fetched ${transactions.length} transactions.');
      return transactions;
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while fetching transactions: $e',
          errorCode: null);
      throw Exception('Failed to load transactions: $e');
    }
  }

  @override
  Future<AmountSummary> getAmountSummary() async {
    const functionName = '$className.getAmountSummary';
    logStarting(
        functionName: functionName,
        message: 'Fetching amount summary from Hive.');

    try {
      logProcessing(
          functionName: functionName,
          message: 'Reading summary data from box.');
      final Map<String, dynamic> summaryData =
          Map<String, dynamic>.from(_box.get(amountListDatabase) ?? {});

      if (summaryData.isEmpty) {
        logInfo(
            functionName: functionName,
            message: 'Summary data is empty. Returning default empty summary.');
        return AmountSummary.empty;
      }

      logSuccess(
          functionName: functionName,
          message: 'Successfully fetched amount summary.');
      return AmountSummary.fromJson(summaryData);
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while fetching amount summary: $e',
          errorCode: null);
      throw Exception('Failed to load amount summary: $e');
    }
  }

  @override
  Future<User> getUserDetails() async {
    const functionName = '$className.getUserDetails';
    logStarting(
        functionName: functionName,
        message: 'Fetching user details from Hive.');

    try {
      logProcessing(
          functionName: functionName, message: 'Reading user data from box.');
      final Map<String, dynamic> userData =
          Map<String, dynamic>.from(_box.get(userDataDatabase) ?? {});

      if (userData.isEmpty) {
        logInfo(
            functionName: functionName,
            message: 'User data is empty. Returning default empty user.');
        return User.empty;
      }

      logSuccess(
          functionName: functionName,
          message: 'Successfully fetched user details.');
      return User.fromJson(userData);
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while fetching user details: $e',
          errorCode: null);
      throw Exception('Failed to load user details: $e');
    }
  }

  @override
  Future<void> addAccount(AccountModel account) async {
    const functionName = '$className.addAccount';
    logStarting(
        functionName: functionName, message: 'Adding new account: $account');

    try {
      logProcessing(
          functionName: functionName, message: 'Fetching existing accounts.');
      final accounts = await getAccounts();

      logOngoing(
          functionName: functionName,
          message: 'Checking if account already exists.');
      final exists = accounts.any((acc) => acc.id == account.id);
      if (exists) {
        logFailure(
            functionName: functionName,
            message: 'Account with name "${account.name}" already exists.');
        throw Exception('Account with this name already exists');
      }

      accounts.add(account);
      logProcessing(
          functionName: functionName,
          message: 'Saving updated account list to Hive.');
      await _box.put(
          accountDatabase, accounts.map((acc) => acc.toJson()).toList());

      logProcessing(
          functionName: functionName, message: 'Updating amount summary.');
      final summary = await getAmountSummary();
      final updatedSummary = summary.copyWith(
        totalIncome: summary.totalIncome + account.currentBalance,
        currentBalance: summary.currentBalance + account.currentBalance,
      );
      await updateAmountSummary(updatedSummary);

      logSuccess(
          functionName: functionName,
          message: 'Account "${account.name}" added successfully.');
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while adding account: $e',
          errorCode: null);
      throw Exception('Failed to add account: $e');
    }
  }

  @override
  Future<void> updateAccount(AccountModel account) {
    const functionName = '$className.updateAccount';
    logStarting(
        functionName: functionName,
        message: 'Updating account: ${account.name}');

    return getAccounts().then((accounts) {
      final index = accounts.indexWhere((acc) => acc.id == account.id);
      if (index == -1) {
        logFailure(
            functionName: functionName,
            message: 'Account not found for update.');
        throw Exception('Account not found');
      }

      accounts[index] = account;

      return _box.put(
          accountDatabase, accounts.map((acc) => acc.toJson()).toList());
    }).then((_) {
      logSuccess(
          functionName: functionName,
          message: 'Account "${account.name}" updated successfully.');
    }).catchError((e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while updating account: $e',
          errorCode: null);
      throw Exception('Failed to update account: $e');
    });
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    const functionName = '$className.addTransaction';
    logStarting(
        functionName: functionName,
        message: 'Adding new transaction: $transaction');

    try {
      logProcessing(
          functionName: functionName,
          message:
              'Fetching existing transactions and Adding new transaction to the list.');
      final transactions = await getTransactions();

      transactions.add(transaction);

      transactions.sort((a, b) => a.createdDate.compareTo(b.createdDate));

      logProcessing(
          functionName: functionName,
          message: 'Saving updated transactions to Hive.');
      await _box.put(
        transactionDatabase,
        transactions.map((trans) => trans.toJson()).toList(),
      );

      logProcessing(
          functionName: functionName,
          message: 'Updating balances for the new transaction.');
      await _updateBalancesForTransaction(transaction, isAdd: true);

      logSuccess(
          functionName: functionName,
          message: 'Transaction "${transaction.name}" added successfully.');
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while adding transaction: $e',
          errorCode: null);
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    const functionName = '$className.updateTransaction';
    logStarting(
        functionName: functionName,
        message: 'Updating transaction: ${transaction.name}');

    try {
      logProcessing(
          functionName: functionName,
          message: 'Fetching existing transactions.');
      final transactions = await getTransactions();

      logOngoing(
          functionName: functionName,
          message: 'Locating transaction by created date.');
      final index = transactions
          .indexWhere((trans) => trans.createdDate == transaction.createdDate);

      if (index == -1) {
        logFailure(
            functionName: functionName,
            message: 'Transaction not found for update.');
        throw Exception('Transaction not found');
      }

      final oldTransaction = transactions[index];
      transactions[index] = transaction;

      logProcessing(
          functionName: functionName,
          message: 'Saving updated transactions to Hive.');
      await _box.put(
        transactionDatabase,
        transactions.map((trans) => trans.toJson()).toList(),
      );

      logProcessing(
          functionName: functionName,
          message: 'Recalculating balances (remove old, add new).');
      await _updateBalancesForTransaction(oldTransaction, isAdd: false);
      await _updateBalancesForTransaction(transaction, isAdd: true);

      logSuccess(
          functionName: functionName,
          message: 'Transaction "${transaction.name}" updated successfully.');
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while updating transaction: $e',
          errorCode: null);
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    const functionName = '$className.updateUser';
    logStarting(functionName: functionName, message: 'Updating user data.');

    try {
      logProcessing(
          functionName: functionName, message: 'Saving user data to Hive.');
      await _box.put(userDataDatabase, user.toJson());

      logSuccess(
          functionName: functionName,
          message: 'User data updated successfully.');
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while updating user: $e',
          errorCode: null);
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> updateAmountSummary(AmountSummary summary) async {
    const functionName = '$className.updateAmountSummary';
    logStarting(
        functionName: functionName, message: 'Updating amount summary.');

    try {
      logProcessing(
          functionName: functionName,
          message: 'Saving amount summary to Hive.');
      await _box.put(amountListDatabase, summary.toJson());

      logSuccess(
          functionName: functionName,
          message: 'Amount summary updated successfully.');
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while updating amount summary: $e',
          errorCode: null);
      throw Exception('Failed to update amount summary: $e');
    }
  }

  @override
  Future<void> deleteAllData() async {
    const functionName = '$className.deleteAllData';
    logStarting(
        functionName: functionName, message: 'Deleting all stored data.');

    try {
      logProcessing(
          functionName: functionName, message: 'Deleting account database.');
      await _box.delete(accountDatabase);

      logProcessing(
          functionName: functionName,
          message: 'Deleting transaction database.');
      await _box.delete(transactionDatabase);

      logProcessing(
          functionName: functionName,
          message: 'Deleting amount summary database.');
      await _box.delete(amountListDatabase);

      logProcessing(
          functionName: functionName, message: 'Deleting user data database.');
      await _box.delete(userDataDatabase);

      logOngoing(
          functionName: functionName,
          message: 'Re-initializing with default account.');
      await addAccount(AccountModel(
        id: generateUniqueId(),
        name: miscellaneousaccountNameD,
        currentBalance: 0,
        iconIndex: 0,
      ));

      logSuccess(
          functionName: functionName,
          message: 'All data deleted and default account added successfully.');
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while deleting all data: $e',
          errorCode: null);
      throw Exception('Failed to delete all data: $e');
    }
  }

  @override
  Future<void> recalculateBalances() async {
    const functionName = '$className.recalculateBalances';
    logStarting(
        functionName: functionName, message: 'Recalculating account balances.');

    try {
      logProcessing(
          functionName: functionName,
          message: 'Fetching accounts and transactions.');
      final accounts = await getAccounts();
      final transactions = await getTransactions();

      logOngoing(
          functionName: functionName,
          message: 'Resetting account balances to 0.');
      final updatedAccounts = accounts
          .map((account) => account.copyWith(currentBalance: 0))
          .toList();

      int totalIncome = 0;
      int totalExpenses = 0;
      int toPay = 0;
      int toReceive = 0;

      logProcessing(
          functionName: functionName,
          message: 'Recalculating balances based on transactions.');
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
            case TransactionType.transfer:
              // TODO: Handle this case.
              throw UnimplementedError();
          }
        }
      }

      logProcessing(
          functionName: functionName,
          message: 'Saving updated accounts to Hive.');
      // Save updated accounts
      await _box.put(
          accountDatabase, updatedAccounts.map((acc) => acc.toJson()).toList());

      logProcessing(
          functionName: functionName, message: 'Updating amount summary.');
      // Update amount summary
      final summary = AmountSummary(
        currentBalance: totalIncome - totalExpenses,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        toPay: toPay,
        toReceive: toReceive,
      );
      await updateAmountSummary(summary);

      logSuccess(
          functionName: functionName,
          message: 'Balances recalculated and saved successfully.');
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while recalculating balances: $e',
          errorCode: null);
      throw Exception('Failed to recalculate balances: $e');
    }
  }

  Future<void> _updateBalancesForTransaction(Transaction transaction,
      {required bool isAdd}) async {
    const functionName = '$className._updateBalancesForTransaction';
    logStarting(
        functionName: functionName,
        message: 'Updating balances for transaction.');

    try {
      logProcessing(
          functionName: functionName,
          message: 'Fetching account summary and account details.');
      final summary = await getAmountSummary();
      final accounts = await getAccounts();

      final accountIndex =
          accounts.indexWhere((acc) => acc.name == transaction.account);

      if (accountIndex == -1) {
        logFailure(
            functionName: functionName,
            message: 'Account not found for transaction.');
        return;
      }

      final multiplier = isAdd ? 1 : -1;
      final amount = transaction.amount * multiplier;

      AmountSummary updatedSummary = summary;
      AccountModel updatedAccount = accounts[accountIndex];

      logOngoing(
          functionName: functionName,
          message: 'Processing transaction type: ${transaction.type}.');
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
        case TransactionType.transfer:
          // TODO: Handle this case.
          throw UnimplementedError();
      }

      logProcessing(
          functionName: functionName,
          message: 'Saving updated account and summary.');
      // Update account
      accounts[accountIndex] = updatedAccount;
      await _box.put(
          accountDatabase, accounts.map((acc) => acc.toJson()).toList());

      // Update summary
      await updateAmountSummary(updatedSummary);

      logSuccess(
          functionName: functionName,
          message: 'Balances updated successfully for transaction.');
    } catch (e) {
      logError(
          functionName: functionName,
          message: 'Exception caught while updating balances: $e',
          errorCode: null);
      throw Exception('Failed to update balances for transaction: $e');
    }
  }
}
