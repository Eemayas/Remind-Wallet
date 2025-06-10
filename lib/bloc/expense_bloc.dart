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
    on<LoadExpenseData>(_onLoadExpenseData);
    on<AddAccount>(_onAddAccount);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteAllData>(_onDeleteAllData);
    on<RecalculateBalances>(_onRecalculateBalances);
    on<CompleteTransaction>(_onCompleteTransaction);
  }

  Future<void> _onLoadExpenseData(
    LoadExpenseData event,
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
    AddAccount event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.addAccount(event.account);
      add(LoadExpenseData());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.addTransaction(event.transaction);
      add(LoadExpenseData());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.updateTransaction(event.transaction);
      add(LoadExpenseData());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUser event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.updateUser(event.user);
      add(LoadExpenseData());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteAllData(
    DeleteAllData event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.deleteAllData();
      add(LoadExpenseData());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRecalculateBalances(
    RecalculateBalances event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _repository.recalculateBalances();
      add(LoadExpenseData());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCompleteTransaction(
    CompleteTransaction event,
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
      add(LoadExpenseData());
    } catch (e) {
      emit(state.copyWith(
        status: ExpenseStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
