import 'package:equatable/equatable.dart';
import 'package:remind_wallet/global/utils/generate_unique_id.dart';
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
    iconIndex: 8,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Transportation',
    iconIndex: 3,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Clothing',
    iconIndex: 4,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Health',
    iconIndex: 9,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Education',
    iconIndex: 5,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Rent',
    iconIndex: 10,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Insurance',
    iconIndex: 11,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Shopping',
    iconIndex: 12,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Entertainment',
    iconIndex: 7,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Mobile & Internet',
    iconIndex: 15,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Fuel',
    iconIndex: 16,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Travel',
    iconIndex: 17,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Pets',
    iconIndex: 19,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Bills',
    iconIndex: 2,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Baby Supplies',
    iconIndex: 0,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.expense,
    name: 'Personal Care',
    iconIndex: 1,
  ),

  // INCOME categories
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Salary',
    iconIndex: 20,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Business',
    iconIndex: 21,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Bonus',
    iconIndex: 22,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Gift',
    iconIndex: 25,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Investment',
    iconIndex: 24,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Freelance',
    iconIndex: 28,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Savings',
    iconIndex: 23,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Scholarship',
    iconIndex: 29,
  ),
  CategoryModel(
    id: generateUniqueId(),
    type: TransactionType.income,
    name: 'Award',
    iconIndex: 30,
  ),
];
