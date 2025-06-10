import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String name;
  final int currentBalance;

  const Account({
    required this.name,
    required this.currentBalance,
  });

  Account copyWith({
    String? name,
    int? currentBalance,
  }) {
    return Account(
      name: name ?? this.name,
      currentBalance: currentBalance ?? this.currentBalance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountNameD': name,
      'accountCurrentBalanceD': currentBalance,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['accountNameD'] ?? '',
      currentBalance: json['accountCurrentBalanceD'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [name, currentBalance];
}
