import 'package:flutter/material.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/models/transaction_icon.dart';
import 'package:remind_wallet/theme/color.dart';

class AccountCard extends StatelessWidget {
  final AccountModel account;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const AccountCard({
    super.key,
    required this.account,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
