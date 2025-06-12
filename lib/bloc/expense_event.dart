import 'package:equatable/equatable.dart';

import '../models/account_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadExpenseDataEvent extends ExpenseEvent {}

class AddAccountEvent extends ExpenseEvent {
  final AccountModel account;

  const AddAccountEvent(this.account);

  @override
  List<Object> get props => [account];
}

class UpdateAccountEvent extends ExpenseEvent {
  final AccountModel account;

  const UpdateAccountEvent(this.account);

  @override
  List<Object> get props => [account];
}

class DeleteAccountEvent extends ExpenseEvent {
  final AccountModel account;

  const DeleteAccountEvent(this.account);

  @override
  List<Object> get props => [account];
}

class AddTransactionEvent extends ExpenseEvent {
  final Transaction transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class UpdateTransactionEvent extends ExpenseEvent {
  final Transaction transaction;

  const UpdateTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class ModifyUserEvent extends ExpenseEvent {
  final User user;

  const ModifyUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class DeleteAllDataEvent extends ExpenseEvent {}

class RecalculateBalancesEvent extends ExpenseEvent {}

class CompleteTransactionEvent extends ExpenseEvent {
  final String transactionId;

  const CompleteTransactionEvent(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}
