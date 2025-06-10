import 'package:equatable/equatable.dart';

enum TransactionType { income, expense, toPay, toReceive }

class Transaction extends Equatable {
  final String name;
  final int amount;
  final TransactionType type;
  final String tag;
  final String date;
  final String account;
  final String person;
  final String description;
  final String icon;
  final String createdDate;

  const Transaction({
    required this.name,
    required this.amount,
    required this.type,
    required this.tag,
    required this.date,
    required this.account,
    required this.person,
    required this.description,
    required this.icon,
    required this.createdDate,
  });

  Transaction copyWith({
    String? name,
    int? amount,
    TransactionType? type,
    String? tag,
    String? date,
    String? account,
    String? person,
    String? description,
    String? icon,
    String? createdDate,
  }) {
    return Transaction(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      tag: tag ?? this.tag,
      date: date ?? this.date,
      account: account ?? this.account,
      person: person ?? this.person,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transationNameD': name,
      'transactionAmountD': amount,
      'transactionTypeD': _typeToString(type),
      'transactionTagD': tag,
      'transactionDateD': date,
      'transactionAccountD': account,
      'transactionPersonD': person,
      'transactionDescriptionD': description,
      'transactionIconD': icon,
      'transactionCreatedDateD': createdDate,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      name: json['transationNameD'] ?? '',
      amount: json['transactionAmountD'] ?? 0,
      type: _stringToType(json['transactionTypeD'] ?? ''),
      tag: json['transactionTagD'] ?? '',
      date: json['transactionDateD'] ?? '',
      account: json['transactionAccountD'] ?? '',
      person: json['transactionPersonD'] ?? '',
      description: json['transactionDescriptionD'] ?? '',
      icon: json['transactionIconD'] ?? '',
      createdDate: json['transactionCreatedDateD'] ?? '',
    );
  }

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
      default:
        return TransactionType.expense;
    }
  }

  @override
  List<Object?> get props => [
        name,
        amount,
        type,
        tag,
        date,
        account,
        person,
        description,
        icon,
        createdDate,
      ];
}
