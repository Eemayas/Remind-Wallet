import 'package:equatable/equatable.dart';
import 'package:remind_wallet/models/category_model.dart';

import '../models/account_model.dart';
import '../models/amount_summary_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

enum ExpenseStatus { initial, loading, success, failure }

class ExpenseState extends Equatable {
  final ExpenseStatus status;
  final List<AccountModel> accounts;
  final List<CategoryModel> categories;
  final List<Transaction> transactions;
  final AmountSummary amountSummary;
  final User user;
  final String? errorMessage;

  const ExpenseState({
    this.status = ExpenseStatus.initial,
    this.accounts = const [],
    this.categories = const [],
    this.transactions = const [],
    this.amountSummary = AmountSummary.empty,
    this.user = User.empty,
    this.errorMessage,
  });

  ExpenseState copyWith({
    ExpenseStatus? status,
    List<AccountModel>? accounts,
    List<CategoryModel>? categories,
    List<Transaction>? transactions,
    AmountSummary? amountSummary,
    User? user,
    String? errorMessage,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
      amountSummary: amountSummary ?? this.amountSummary,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        accounts,
        categories,
        transactions,
        amountSummary,
        user,
        errorMessage,
      ];
}
