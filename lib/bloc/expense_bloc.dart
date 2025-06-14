import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_wallet/global/utils/logger.dart';

import '../models/transaction_model.dart';
import '../repositories/expense_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _repository;

  ExpenseBloc({required ExpenseRepository repository})
      : _repository = repository,
        super(const ExpenseState()) {
    on<LoadExpenseDataEvent>(_onLoadExpenseData);
    on<AddAccountEvent>(_onAddAccount);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<AddTransactionEvent>(_onAddTransaction);

    on<UpdateTransactionEvent>(_onUpdateTransaction);

    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);

    on<ModifyUserEvent>(_onUpdateUser);
    on<DeleteAllDataEvent>(_onDeleteAllData);
    on<RecalculateBalancesEvent>(_onRecalculateBalances);
    on<CompleteTransactionEvent>(_onCompleteTransaction);
  }
  static const String functionName = 'ExpenseBloc';

  Future<void> _onLoadExpenseData(
    LoadExpenseDataEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    String functionName = '$ExpenseBloc._onLoadExpenseData';

    emit(state.copyWith(status: ExpenseStatus.loading));
    try {
      final accounts = await _repository.getAccounts();
      logInfo(
          functionName: functionName,
          message: 'Fetched ${accounts.length} accounts.');

      final transactions = await _repository.getTransactions();
      logInfo(
          functionName: functionName,
          message: 'Fetched ${transactions.length} transactions.');

      final categories = await _repository.getCategories();
      logInfo(
          functionName: functionName,
          message: 'Fetched ${categories.length} categories.');

      final amountSummary = await _repository.getAmountSummary();
      logInfo(
          functionName: functionName,
          message: 'Fetched amount summary: $amountSummary');

      final user = await _repository.getUserDetails();
      logInfo(
          functionName: functionName,
          message: 'Fetched user details: ${user.name}');

      emit(state.copyWith(
        status: ExpenseStatus.success,
        accounts: accounts,
        transactions: transactions,
        categories: categories,
        amountSummary: amountSummary,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddAccount(
    AddAccountEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.addAccount(event.account);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccountEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.updateAccount(event.account);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.deleteAccount(event.account);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddTransaction(
    AddTransactionEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.addTransaction(event.transaction);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.updateTransaction(event.transaction);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.addCategory(event.category);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.updateCategory(event.category);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.deleteCategory(event.category);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateUser(
    ModifyUserEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.updateUser(event.user);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteAllData(
    DeleteAllDataEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.deleteAllData();
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRecalculateBalances(
    RecalculateBalancesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.recalculateBalances();
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCompleteTransaction(
    CompleteTransactionEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      final transaction = state.transactions.firstWhere(
        (trans) => trans.createdDate == event.transactionId,
      );

      final updatedTransaction = transaction.copyWith(
        type: transaction.type == TransactionType.toPay
            ? TransactionType.expense
            : TransactionType.income,
      );

      await _repository.updateTransaction(updatedTransaction);
      add(LoadExpenseDataEvent());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
