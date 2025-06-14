import 'package:flutter/material.dart';
import 'package:remind_wallet/models/transaction_model.dart';
import 'package:remind_wallet/theme/color.dart';

class TransactionTabSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const TransactionTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TransactionType.income.name,
      TransactionType.expense.name,
      TransactionType.toPay.name,
      TransactionType.toReceive.name,
      TransactionType.transfer.name,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(tabs.length * 2 - 1, (i) {
          if (i.isOdd) {
            return _buildDivider();
          } else {
            int tabIndex = i ~/ 2;
            return _buildTab(context, tabs[tabIndex], tabIndex);
          }
        }),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            Icon(Icons.check_circle,
                color: AppColors.optionSelectedColor, size: 15),
          if (isSelected) const SizedBox(width: 5),
          Text(
            title
                .replaceAllMapped(
                  RegExp(r'([a-z])([A-Z])'),
                  (match) => '${match.group(1)} ${match.group(2)}',
                )
                .toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(
        width: 1,
        height: 20,
        color: Colors.grey.withOpacity(0.3),
      );
}
