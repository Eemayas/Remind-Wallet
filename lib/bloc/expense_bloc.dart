import 'package:flutter_bloc/flutter_bloc.dart';

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
    on<AddTransactionEvent>(_onAddTransaction);
    on<UpdateTransactionEvent>(_onUpdateTransaction);
    on<ModifyUserEvent>(_onUpdateUser);
    on<DeleteAllDataEvent>(_onDeleteAllData);
    on<RecalculateBalancesEvent>(_onRecalculateBalances);
    on<CompleteTransactionEvent>(_onCompleteTransaction);
  }

  Future<void> _onLoadExpenseData(
    LoadExpenseDataEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    try {
      final accounts = await _repository.getAccounts();
      final transactions = await _repository.getTransactions();
      final amountSummary = await _repository.getAmountSummary();
      final user = await _repository.getUserDetails();

      emit(state.copyWith(
        status: ExpenseStatus.success,
        accounts: accounts,
        transactions: transactions,
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
