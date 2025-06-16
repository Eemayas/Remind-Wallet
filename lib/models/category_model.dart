import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remind_wallet/global/utils/generate_unique_id.dart';
import 'package:remind_wallet/models/transaction_icon.dart';
import 'package:remind_wallet/models/transaction_model.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final int? iconIndex;
  final TransactionType type;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.iconIndex,
  });

  CategoryModel copyWith(
      {String? name, int? iconIndex, String? id, TransactionType? type}) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconIndex: iconIndex ?? this.iconIndex,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryNameD': name,
      'categoryIconIndexD': iconIndex,
      'categoryTypeD': type.index,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['categoryNameD'] ?? '',
      iconIndex: json['categoryIconIndexD'] ?? 0,
      type: TransactionType
          .values[json['categoryTypeD'] ?? TransactionType.expense.index],
    );
  }

  static const CategoryModel empty = CategoryModel(
    id: '',
    name: '',
    type: TransactionType.expense,
    iconIndex: 0,
  );

  @override
  List<Object?> get props => [id, name, iconIndex];
}

final List<CategoryModel> defaultCategories = [
  // EXPENSE categories
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Food & Drinks',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.utensils,
        color: Colors.green,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Transportation',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.bus,
        color: Colors.blue,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Clothing',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.shirt,
        color: Colors.orange,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Health',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.briefcaseMedical,
        color: Colors.red,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Education',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.graduationCap,
        color: Colors.blue,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Rent',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.house,
        color: Colors.brown,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Insurance',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.shieldHalved,
        color: Colors.indigo,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Shopping',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.bagShopping,
        color: Colors.pink,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Entertainment',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.film,
        color: Colors.amber,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Mobile & Internet',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.wifi,
        color: Colors.deepPurple,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Fuel',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.gasPump,
        color: Colors.orangeAccent,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Travel',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.bus,
        color: Colors.indigo,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Pets',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.paw,
        color: Colors.brown,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Bills',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.fileInvoiceDollar,
        color: Colors.deepOrange,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Baby Supplies',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.baby,
        color: Colors.purpleAccent,
        type: TransactionType.expense,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Personal Care',
    iconIndex: TransactionIcon.getExpenseCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.soap,
        color: Colors.pinkAccent,
        type: TransactionType.expense,
      ),
    ),
  ),

  // INCOME categories
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Salary',
    iconIndex: TransactionIcon.getIncomeCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.moneyBill1Wave,
        color: Colors.green,
        type: TransactionType.income,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Business',
    iconIndex: TransactionIcon.getIncomeCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.briefcase,
        color: Colors.purple,
        type: TransactionType.income,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Bonus',
    iconIndex: TransactionIcon.getIncomeCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.chartLine,
        color: Colors.lightGreen,
        type: TransactionType.income,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Gift',
    iconIndex: TransactionIcon.getIncomeCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.gift,
        color: Colors.pink,
        type: TransactionType.income,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Investment',
    iconIndex: TransactionIcon.getIncomeCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.chartLine,
        color: Colors.cyan,
        type: TransactionType.income,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Freelance',
    iconIndex: TransactionIcon.getIncomeCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.receipt,
        color: Colors.blueGrey,
        type: TransactionType.income,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Savings',
    iconIndex: TransactionIcon.getIncomeCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.piggyBank,
        color: Colors.deepPurple,
        type: TransactionType.income,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Scholarship',
    iconIndex: TransactionIcon.getIncomeCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.university,
        color: Colors.cyan,
        type: TransactionType.income,
      ),
    ),
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Award',
    iconIndex: TransactionIcon.getIncomeCategoryIconIndex(
      TransactionIcon(
        icon: FontAwesomeIcons.award,
        color: Colors.amber,
        type: TransactionType.income,
      ),
    ),
  ),
];
