import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String phone;
  final String email;
  final String dateOfBirth;

  const User({
    required this.name,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
  });

  User copyWith({
    String? name,
    String? phone,
    String? email,
    String? dateOfBirth,
  }) {
    return User(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userNameD': name,
      'userPhoneD': phone,
      'userEmailD': email,
      'userDOBD': dateOfBirth,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['userNameD'] ?? 'User',
      phone: json['userPhoneD'] ?? '9800000000',
      email: json['userEmailD'] ?? 'xyz@example.com',
      dateOfBirth: json['userDOBD'] ?? '0000-00-00',
    );
  }

  static const User empty = User(
    name: 'User',
    phone: '9800000000',
    email: 'xyz@example.com',
    dateOfBirth: '0000-00-00',
  );

  @override
  List<Object?> get props => [name, phone, email, dateOfBirth];
}
