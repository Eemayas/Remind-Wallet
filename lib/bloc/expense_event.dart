import 'package:equatable/equatable.dart';

import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadExpenseData extends ExpenseEvent {}

class AddAccount extends ExpenseEvent {
  final Account account;

  const AddAccount(this.account);

  @override
  List<Object> get props => [account];
}

class AddTransaction extends ExpenseEvent {
  final Transaction transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class UpdateTransaction extends ExpenseEvent {
  final Transaction transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class UpdateUser extends ExpenseEvent {
  final User user;

  const UpdateUser(this.user);

  @override
  List<Object> get props => [user];
}

class DeleteAllData extends ExpenseEvent {}

class RecalculateBalances extends ExpenseEvent {}

class CompleteTransaction extends ExpenseEvent {
  final String transactionId;

  const CompleteTransaction(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}
