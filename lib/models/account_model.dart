import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final String id;
  final int? iconIndex;
  final String name;
  final int currentBalance;

  const AccountModel({
    required this.id,
    required this.name,
    required this.currentBalance,
    this.iconIndex,
  });

  AccountModel copyWith({String? name, int? currentBalance, int? iconIndex}) {
    return AccountModel(
      id: id,
      name: name ?? this.name,
      currentBalance: currentBalance ?? this.currentBalance,
      iconIndex: iconIndex ?? this.iconIndex,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNameD': name,
      'accountCurrentBalanceD': currentBalance,
      'accountIconIndexD': iconIndex,
    };
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] ?? '',
      name: json['accountNameD'] ?? '',
      currentBalance: json['accountCurrentBalanceD'] ?? 0,
      iconIndex: json['accountIconIndexD'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, currentBalance, iconIndex];
}
