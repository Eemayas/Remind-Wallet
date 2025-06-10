import 'package:equatable/equatable.dart';

class AmountSummary extends Equatable {
  final int currentBalance;
  final int totalIncome;
  final int totalExpenses;
  final int toReceive;
  final int toPay;

  const AmountSummary({
    required this.currentBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.toReceive,
    required this.toPay,
  });

  AmountSummary copyWith({
    int? currentBalance,
    int? totalIncome,
    int? totalExpenses,
    int? toReceive,
    int? toPay,
  }) {
    return AmountSummary(
      currentBalance: currentBalance ?? this.currentBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      toReceive: toReceive ?? this.toReceive,
      toPay: toPay ?? this.toPay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentBalanceD': currentBalance,
      'totalIncomeD': totalIncome,
      'totalExpensesD': totalExpenses,
      'toReceiveD': toReceive,
      'toPayD': toPay,
    };
  }

  factory AmountSummary.fromJson(Map<String, dynamic> json) {
    return AmountSummary(
      currentBalance: json['currentBalanceD'] ?? 0,
      totalIncome: json['totalIncomeD'] ?? 0,
      totalExpenses: json['totalExpensesD'] ?? 0,
      toReceive: json['toReceiveD'] ?? 0,
      toPay: json['toPayD'] ?? 0,
    );
  }

  static const AmountSummary empty = AmountSummary(
    currentBalance: 0,
    totalIncome: 0,
    totalExpenses: 0,
    toReceive: 0,
    toPay: 0,
  );

  @override
  List<Object?> get props => [
        currentBalance,
        totalIncome,
        totalExpenses,
        toReceive,
        toPay,
      ];
}
