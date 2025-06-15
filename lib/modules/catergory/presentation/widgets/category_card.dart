import 'package:flutter/material.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/models/category_model.dart';
import 'package:remind_wallet/models/transaction_icon.dart';
import 'package:remind_wallet/models/transaction_model.dart';
import 'package:remind_wallet/theme/color.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    print("CategoryCard created - II: $category ${category.type} ");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.cardborderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Color(0xFF4C4C4C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.type == TransactionType.income
                  ? initialIncomeCategoryIcons[category.iconIndex ?? 0].icon
                  : initialExpenseCategoryIcons[category.iconIndex ?? 0].icon,
              color: category.type == TransactionType.income
                  ? initialIncomeCategoryIcons[category.iconIndex ?? 0].color
                  : initialExpenseCategoryIcons[category.iconIndex ?? 0].color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 4),
              ],
            ),
          ),
          PopupMenuButton<String>(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor,
            icon: Icon(
              Icons.more_horiz,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit,
                        color: Theme.of(context).iconTheme.color, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Edit',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete,
                        color: Theme.of(context).iconTheme.color, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Delete',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountSmallCard extends StatelessWidget {
  final AccountModel account;

  const AccountSmallCard({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF3C3C3C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF4C4C4C),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF4C4C4C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              initialAccountCategoryIcons[account.iconIndex ?? 0].icon,
              color: initialAccountCategoryIcons[account.iconIndex ?? 0].color,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Balance: ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: 'Rs. ${account.currentBalance}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: account.currentBalance >= 0
                                  ? AppColors.incomeColor
                                  : AppColors.expenseColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_horiz,
            color: Color(0xFFFFD700),
            size: 24,
          ),
        ],
      ),
    );
  }
}
