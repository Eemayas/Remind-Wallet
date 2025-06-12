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
          message:
              'Recalculating balances based on ${transactions.length} transactions.');

      // Recalculate based on transactions
      for (final transaction in transactions) {
        final accountIndex = updatedAccounts
            .indexWhere((acc) => acc.name == transaction.account);

        if (accountIndex != -1) {
          final currentBalance = updatedAccounts[accountIndex].currentBalance;

          switch (transaction.type) {
            case TransactionType.income:
              logInfo(
                  functionName: functionName,
                  message:
                      'INCOME - Transaction: ${transaction.name}, Amount: ${transaction.amount} | '
                      'Account: ${transaction.account} | '
                      'totalIncome: $totalIncome -> ${totalIncome + transaction.amount} | '
                      'Account Balance: $currentBalance -> ${currentBalance + transaction.amount}');
              totalIncome += transaction.amount;
              updatedAccounts[accountIndex] = updatedAccounts[accountIndex]
                  .copyWith(
                      currentBalance: currentBalance + transaction.amount);
              break;

            case TransactionType.expense:
              logInfo(
                  functionName: functionName,
                  message:
                      'EXPENSE - Transaction: ${transaction.name}, Amount: ${transaction.amount} | '
                      'Account: ${transaction.account} | '
                      'totalExpenses: $totalExpenses -> ${totalExpenses + transaction.amount} | '
                      'Account Balance: $currentBalance -> ${currentBalance - transaction.amount}');
              totalExpenses += transaction.amount;
              updatedAccounts[accountIndex] = updatedAccounts[accountIndex]
                  .copyWith(
                      currentBalance: currentBalance - transaction.amount);
              break;

            case TransactionType.toPay:
              logInfo(
                  functionName: functionName,
                  message:
                      'TO_PAY - Transaction: ${transaction.name}, Amount: ${transaction.amount} | '
                      'Account: ${transaction.account} | '
                      'toPay: $toPay -> ${toPay + transaction.amount} | '
                      'Account Balance: $currentBalance -> ${currentBalance - transaction.amount}');
              toPay += transaction.amount;
              updatedAccounts[accountIndex] = updatedAccounts[accountIndex]
                  .copyWith(
                      currentBalance: currentBalance - transaction.amount);
              break;

            case TransactionType.toReceive:
              logInfo(
                  functionName: functionName,
                  message:
                      'TO_RECEIVE - Transaction: ${transaction.name}, Amount: ${transaction.amount} | '
                      'Account: ${transaction.account} | '
                      'toReceive: $toReceive -> ${toReceive + transaction.amount} | '
                      'Account Balance: $currentBalance -> ${currentBalance + transaction.amount}');
              toReceive += transaction.amount;
              updatedAccounts[accountIndex] = updatedAccounts[accountIndex]
                  .copyWith(
                      currentBalance: currentBalance + transaction.amount);
              break;

            case TransactionType.transfer:
              // Handle transfer between accounts
              if (transaction.fromAccountId != null &&
                  transaction.toAccountId != null) {
                final fromAccountIndex = updatedAccounts
                    .indexWhere((acc) => acc.id == transaction.fromAccountId);
                final toAccountIndex = updatedAccounts
                    .indexWhere((acc) => acc.id == transaction.toAccountId);

                if (fromAccountIndex != -1 && toAccountIndex != -1) {
                  final fromBalance =
                      updatedAccounts[fromAccountIndex].currentBalance;
                  final toBalance =
                      updatedAccounts[toAccountIndex].currentBalance;

                  logInfo(
                      functionName: functionName,
                      message:
                          'TRANSFER - Transaction: ${transaction.name}, Amount: ${transaction.amount} | '
                          'From Account: ${updatedAccounts[fromAccountIndex].name} ($fromBalance -> ${fromBalance - transaction.amount}) | '
                          'To Account: ${updatedAccounts[toAccountIndex].name} ($toBalance -> ${toBalance + transaction.amount})');

                  updatedAccounts[fromAccountIndex] =
                      updatedAccounts[fromAccountIndex].copyWith(
                          currentBalance: fromBalance - transaction.amount);
                  updatedAccounts[toAccountIndex] =
                      updatedAccounts[toAccountIndex].copyWith(
                          currentBalance: toBalance + transaction.amount);
                } else {
                  logInfo(
                      functionName: functionName,
                      message:
                          'Transfer accounts not found - From: ${transaction.fromAccountId}, To: ${transaction.toAccountId}');
                }
              } else {
                logInfo(
                    functionName: functionName,
                    message:
                        'Transfer transaction missing account IDs: ${transaction.name}');
              }
              break;

            case TransactionType.addAccount:
              logInfo(
                  functionName: functionName,
                  message:
                      'ADD_ACCOUNT - Transaction: ${transaction.name}, Initial Balance: ${transaction.amount} | '
                      'Account: ${transaction.account} | '
                      'Account Balance: $currentBalance -> ${currentBalance + transaction.amount}');
              updatedAccounts[accountIndex] = updatedAccounts[accountIndex]
                  .copyWith(
                      currentBalance: currentBalance + transaction.amount);
              break;

            case TransactionType.updateAccount:
              logInfo(
                  functionName: functionName,
                  message:
                      'UPDATE_ACCOUNT - Transaction: ${transaction.name}, New Balance: ${transaction.amount} | '
                      'Account: ${transaction.account} | '
                      'Account Balance: $currentBalance -> ${transaction.amount}');
              updatedAccounts[accountIndex] = updatedAccounts[accountIndex]
                  .copyWith(currentBalance: transaction.amount);
              break;

            case TransactionType.deleteAccount:
              logInfo(
                  functionName: functionName,
                  message:
                      'DELETE_ACCOUNT - Transaction: ${transaction.name} | '
                      'Account: ${transaction.account} will be removed from calculations');
              // Account deletion should be handled separately
              // This transaction type indicates the account should be excluded
              break;
          }
        } else {
          logInfo(
              functionName: functionName,
              message:
                  'Account not found for transaction: ${transaction.name} (Account: ${transaction.account})');
        }
      }

      // Calculate final current balance
      final finalCurrentBalance = updatedAccounts.fold<int>(
          0, (sum, account) => sum + account.currentBalance);

      logProcessing(
          functionName: functionName,
          message:
              'Final calculations - Total Income: $totalIncome, Total Expenses: $totalExpenses, '
              'To Pay: $toPay, To Receive: $toReceive, Current Balance: $finalCurrentBalance');

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
        currentBalance:
            finalCurrentBalance, // Use calculated balance from accounts
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        toPay: toPay,
        toReceive: toReceive,
      );

      logInfo(
          functionName: functionName,
          message:
              'Summary updated - Current Balance: ${summary.currentBalance}, '
              'Total Income: ${summary.totalIncome}, Total Expenses: ${summary.totalExpenses}, '
              'To Pay: ${summary.toPay}, To Receive: ${summary.toReceive}');

      await updateAmountSummary(summary);

      logSuccess(
          functionName: functionName,
          message: 'Balances recalculated and saved successfully. '
              'Processed ${transactions.length} transactions across ${updatedAccounts.length} accounts.');
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
          // Add income to total income and increase current balance
          logInfo(
              functionName: functionName,
              message: 'INCOME - Amount: $amount | '
                  'Summary: totalIncome ${summary.totalIncome} -> ${summary.totalIncome + amount}, '
                  'currentBalance ${summary.currentBalance} -> ${summary.currentBalance + amount} | '
                  'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance + amount}');
          updatedSummary = summary.copyWith(
            totalIncome: summary.totalIncome + amount,
            currentBalance: summary.currentBalance + amount,
          );
          updatedAccount = updatedAccount.copyWith(
            currentBalance: updatedAccount.currentBalance + amount,
          );
          break;

        case TransactionType.expense:
          // Add to total expenses and decrease current balance
          logInfo(
              functionName: functionName,
              message: 'EXPENSE - Amount: $amount | '
                  'Summary: totalExpenses ${summary.totalExpenses} -> ${summary.totalExpenses + amount}, '
                  'currentBalance ${summary.currentBalance} -> ${summary.currentBalance - amount} | '
                  'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance - amount}');
          updatedSummary = summary.copyWith(
            totalExpenses: summary.totalExpenses + amount,
            currentBalance: summary.currentBalance - amount,
          );
          updatedAccount = updatedAccount.copyWith(
            currentBalance: updatedAccount.currentBalance - amount,
          );
          break;

        case TransactionType.toPay:
          // Increase amount to pay (liability)
          logInfo(
              functionName: functionName,
              message: 'TO_PAY - Amount: $amount | '
                  'Summary: toPay ${summary.toPay} -> ${summary.toPay + amount}, '
                  'currentBalance ${summary.currentBalance} -> ${summary.currentBalance - amount} | '
                  'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance - amount}');
          updatedSummary = summary.copyWith(
            toPay: summary.toPay + amount,
            currentBalance: summary.currentBalance -
                amount, // Decrease balance for liability
          );
          updatedAccount = updatedAccount.copyWith(
            currentBalance: updatedAccount.currentBalance - amount,
          );
          break;

        case TransactionType.toReceive:
          // Increase amount to receive (asset)
          logInfo(
              functionName: functionName,
              message: 'TO_RECEIVE - Amount: $amount | '
                  'Summary: toReceive ${summary.toReceive} -> ${summary.toReceive + amount}, '
                  'currentBalance ${summary.currentBalance} -> ${summary.currentBalance + amount} | '
                  'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance + amount}');
          updatedSummary = summary.copyWith(
            toReceive: summary.toReceive + amount,
            currentBalance: summary.currentBalance +
                amount, // Increase balance for receivable
          );
          updatedAccount = updatedAccount.copyWith(
            currentBalance: updatedAccount.currentBalance + amount,
          );
          break;

        case TransactionType.transfer:
          // Transfer between accounts - handle source and destination
          if (transaction.fromAccountId == updatedAccount.id) {
            // Transferring FROM this account - decrease balance
            logInfo(
                functionName: functionName,
                message: 'TRANSFER_OUT - Amount: $amount | '
                    'From Account: ${updatedAccount.id} | '
                    'Summary: currentBalance ${summary.currentBalance} -> ${summary.currentBalance - amount} | '
                    'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance - amount}');
            updatedSummary = summary.copyWith(
              currentBalance: summary.currentBalance - amount,
            );
            updatedAccount = updatedAccount.copyWith(
              currentBalance: updatedAccount.currentBalance - amount,
            );
          } else if (transaction.toAccountId == updatedAccount.id) {
            // Transferring TO this account - increase balance
            logInfo(
                functionName: functionName,
                message: 'TRANSFER_IN - Amount: $amount | '
                    'To Account: ${updatedAccount.id} | '
                    'Summary: currentBalance ${summary.currentBalance} -> ${summary.currentBalance + amount} | '
                    'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance + amount}');
            updatedSummary = summary.copyWith(
              currentBalance: summary.currentBalance + amount,
            );
            updatedAccount = updatedAccount.copyWith(
              currentBalance: updatedAccount.currentBalance + amount,
            );
          } else {
            // Transfer doesn't involve this account
            logInfo(
                functionName: functionName,
                message: 'Transfer does not involve this account.');
            return;
          }
          break;

        case TransactionType.addAccount:
          // New account added - may need to update summary totals
          // Assuming initial balance is included in the transaction amount
          logInfo(
              functionName: functionName,
              message: 'ADD_ACCOUNT - Amount: $amount | '
                  'Summary: currentBalance ${summary.currentBalance} -> ${summary.currentBalance + amount}');
          updatedSummary = summary.copyWith(
            currentBalance: summary.currentBalance + amount,
          );
          break;

        case TransactionType.updateAccount:
          // Account updated - calculate balance difference
          double balanceDifference =
              (amount - updatedAccount.currentBalance) as double;
          logInfo(
              functionName: functionName,
              message:
                  'UPDATE_ACCOUNT - Amount: $amount | Balance Difference: $balanceDifference | '
                  'Summary: currentBalance ${summary.currentBalance} -> ${summary.currentBalance + balanceDifference} | '
                  'Account: currentBalance ${updatedAccount.currentBalance} -> $amount');
          updatedSummary = summary.copyWith(
            currentBalance:
                (summary.currentBalance + balanceDifference).round(),
          );
          updatedAccount = updatedAccount.copyWith(
            currentBalance: amount, // Set to new balance
          );
          break;

        case TransactionType.deleteAccount:
          // Account deleted - remove its balance from summary
          logInfo(
              functionName: functionName,
              message:
                  'DELETE_ACCOUNT - Removing Account Balance: ${updatedAccount.currentBalance} | '
                  'Summary: currentBalance ${summary.currentBalance} -> ${summary.currentBalance - updatedAccount.currentBalance}');
          updatedSummary = summary.copyWith(
            currentBalance:
                summary.currentBalance - updatedAccount.currentBalance,
          );
          // Note: The account object itself should be removed from the collection
          break;
      }

      // switch (transaction.type) {
      //   case TransactionType.income:
      //     // Add income to total income and increase current balance
      //     logInfo(
      //         functionName: functionName,
      //         message: 'INCOME - Amount: $amount | '
      //             'Summary: totalIncome ${summary.totalIncome} -> ${summary.totalIncome + amount}, '
      //             'currentBalance ${summary.currentBalance} -> ${summary.currentBalance + amount} | '
      //             'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance + amount}');
      //     updatedSummary = summary.copyWith(
      //       totalIncome: summary.totalIncome + amount,
      //       currentBalance: summary.currentBalance + amount,
      //     );
      //     updatedAccount = updatedAccount.copyWith(
      //       currentBalance: updatedAccount.currentBalance + amount,
      //     );
      //     break;

      //   case TransactionType.expense:
      //     // Add to total expenses and decrease current balance
      //     logInfo(
      //         functionName: functionName,
      //         message: 'EXPENSE - Amount: $amount | '
      //             'Summary: totalExpenses ${summary.totalExpenses} -> ${summary.totalExpenses + amount}, '
      //             'currentBalance ${summary.currentBalance} -> ${summary.currentBalance - amount} | '
      //             'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance - amount}');
      //     updatedSummary = summary.copyWith(
      //       totalExpenses: summary.totalExpenses + amount,
      //       currentBalance: summary.currentBalance - amount,
      //     );
      //     updatedAccount = updatedAccount.copyWith(
      //       currentBalance: updatedAccount.currentBalance - amount,
      //     );
      //     break;

      //   case TransactionType.toPay:
      //     // Increase amount to pay (liability)
      //     logInfo(
      //         functionName: functionName,
      //         message: 'TO_PAY - Amount: $amount | '
      //             'Summary: toPay ${summary.toPay} -> ${summary.toPay + amount}, '
      //             'currentBalance ${summary.currentBalance} -> ${summary.currentBalance - amount} | '
      //             'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance - amount}');
      //     updatedSummary = summary.copyWith(
      //       toPay: summary.toPay + amount,
      //       currentBalance: summary.currentBalance -
      //           amount, // Decrease balance for liability
      //     );
      //     updatedAccount = updatedAccount.copyWith(
      //       currentBalance: updatedAccount.currentBalance - amount,
      //     );
      //     break;

      //   case TransactionType.toReceive:
      //     // Increase amount to receive (asset)
      //     logInfo(
      //         functionName: functionName,
      //         message: 'TO_RECEIVE - Amount: $amount | '
      //             'Summary: toReceive ${summary.toReceive} -> ${summary.toReceive + amount}, '
      //             'currentBalance ${summary.currentBalance} -> ${summary.currentBalance + amount} | '
      //             'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance + amount}');
      //     updatedSummary = summary.copyWith(
      //       toReceive: summary.toReceive + amount,
      //       currentBalance: summary.currentBalance +
      //           amount, // Increase balance for receivable
      //     );
      //     updatedAccount = updatedAccount.copyWith(
      //       currentBalance: updatedAccount.currentBalance + amount,
      //     );
      //     break;

      //   case TransactionType.transfer:
      //     // Transfer between accounts - handle source and destination
      //     if (transaction.fromAccountId == updatedAccount.id) {
      //       // Transferring FROM this account - decrease balance
      //       logInfo(
      //           functionName: functionName,
      //           message: 'TRANSFER_OUT - Amount: $amount | '
      //               'From Account: ${updatedAccount.id} | '
      //               'Summary: currentBalance ${summary.currentBalance} -> ${summary.currentBalance - amount} | '
      //               'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance - amount}');
      //       updatedSummary = summary.copyWith(
      //         currentBalance: summary.currentBalance - amount,
      //       );
      //       updatedAccount = updatedAccount.copyWith(
      //         currentBalance: updatedAccount.currentBalance - amount,
      //       );
      //     } else if (transaction.toAccountId == updatedAccount.id) {
      //       // Transferring TO this account - increase balance
      //       logInfo(
      //           functionName: functionName,
      //           message: 'TRANSFER_IN - Amount: $amount | '
      //               'To Account: ${updatedAccount.id} | '
      //               'Summary: currentBalance ${summary.currentBalance} -> ${summary.currentBalance + amount} | '
      //               'Account: currentBalance ${updatedAccount.currentBalance} -> ${updatedAccount.currentBalance + amount}');
      //       updatedSummary = summary.copyWith(
      //         currentBalance: summary.currentBalance + amount,
      //       );
      //       updatedAccount = updatedAccount.copyWith(
      //         currentBalance: updatedAccount.currentBalance + amount,
      //       );
      //     } else {
      //       // Transfer doesn't involve this account
      //       logInfo(
      //           functionName: functionName,
      //           message: 'Transfer does not involve this account.');
      //       return;
      //     }
      //     break;

      //   case TransactionType.addAccount:
      //     // New account added - may need to update summary totals
      //     // Assuming initial balance is included in the transaction amount
      //     logInfo(
      //         functionName: functionName,
      //         message: 'ADD_ACCOUNT - Amount: $amount | '
      //             'Summary: currentBalance ${summary.currentBalance} -> ${summary.currentBalance + amount}');
      //     updatedSummary = summary.copyWith(
      //       currentBalance: summary.currentBalance + amount,
      //     );
      //     break;
      // }

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
