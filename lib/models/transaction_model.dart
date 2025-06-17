import 'package:equatable/equatable.dart';

enum TransactionType {
  income,
  expense,
  toPay,
  toReceive,
  transfer,
  addAccount,
  updateAccount,
  deleteAccount
}

class Transaction extends Equatable {
  final String id;
  final String name;
  final int amount;
  final TransactionType type;
  final String category;
  final String date;
  final String account;
  final String person;
  final String description;
  final String? icon;
  final String createdDate;
  // final String? fromAccountId;
  final String? toAccountId;

  const Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.account,
    required this.person,
    required this.description,
    this.icon,
    required this.createdDate,
    // this.fromAccountId,
    this.toAccountId,
  });

  Transaction copyWith({
    String? id,
    String? name,
    int? amount,
    TransactionType? type,
    String? category,
    String? date,
    String? account,
    String? person,
    String? description,
    String? icon,
    String? createdDate,
    String? fromAccountId,
    String? toAccountId,
  }) {
    return Transaction(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      account: account ?? this.account,
      person: person ?? this.person,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      createdDate: createdDate ?? this.createdDate,
      // fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionIdD': id,
      'transationNameD': name,
      'transactionAmountD': amount,
      'transactionTypeD': _typeToString(type),
      'transactionTagD': category,
      'transactionDateD': date,
      'transactionAccountD': account,
      'transactionPersonD': person,
      'transactionDescriptionD': description,
      'transactionIconD': icon,
      'transactionCreatedDateD': createdDate,
      // 'fromAccountIdD': fromAccountId,
      'toAccountIdD': toAccountId,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['transactionIdD'] ?? '',
      name: json['transationNameD'] ?? '',
      amount: json['transactionAmountD'] ?? 0,
      type: _stringToType(json['transactionTypeD'] ?? ''),
      category: json['transactionTagD'] ?? '',
      date: json['transactionDateD'] ?? '',
      account: json['transactionAccountD'] ?? '',
      person: json['transactionPersonD'] ?? '',
      description: json['transactionDescriptionD'] ?? '',
      icon: json['transactionIconD'] ?? '',
      createdDate: json['transactionCreatedDateD'] ?? '',
      // fromAccountId: json['fromAccountIdD'],
      toAccountId: json['toAccountIdD'],
    );
  }

  DateTime get parsedDateTime => DateTime.parse(date);

  static String _typeToString(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expenses';
      case TransactionType.toPay:
        return 'toPay';
      case TransactionType.toReceive:
        return 'toReceive';
      case TransactionType.transfer:
        return 'transfer';
      case TransactionType.addAccount:
        return 'addAccount';
      case TransactionType.updateAccount:
        return 'updateAccount';
      case TransactionType.deleteAccount:
        return 'deleteAccount';
    }
  }

  static TransactionType _stringToType(String type) {
    switch (type) {
      case 'income':
        return TransactionType.income;
      case 'expenses':
        return TransactionType.expense;
      case 'toPay':
        return TransactionType.toPay;
      case 'toReceive':
        return TransactionType.toReceive;
      case 'transfer':
        return TransactionType.transfer;
      case 'addAccount':
        return TransactionType.addAccount;
      case 'updateAccount':
        return TransactionType.updateAccount;
      case 'deleteAccount':
        return TransactionType.deleteAccount;
      default:
        return TransactionType.expense;
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        type,
        category,
        date,
        account,
        person,
        description,
        icon,
        createdDate,
        // fromAccountId,
        toAccountId,
      ];
}
