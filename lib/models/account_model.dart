import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final int? iconIndex;
  final String name;
  final int currentBalance;

  const AccountModel({
    required this.name,
    required this.currentBalance,
    this.iconIndex,
  });

  AccountModel copyWith({String? name, int? currentBalance, int? iconIndex}) {
    return AccountModel(
      name: name ?? this.name,
      currentBalance: currentBalance ?? this.currentBalance,
      iconIndex: iconIndex ?? this.iconIndex,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountNameD': name,
      'accountCurrentBalanceD': currentBalance,
      'accountIconIndexD': iconIndex,
    };
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      name: json['accountNameD'] ?? '',
      currentBalance: json['accountCurrentBalanceD'] ?? 0,
      iconIndex: json['accountIconIndexD'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [name, currentBalance, iconIndex];
}
