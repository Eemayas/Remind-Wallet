import 'package:flutter/material.dart';
import 'package:remind_wallet/theme/color.dart';

class AccountSummaryHeader extends StatelessWidget {
  final dynamic amountSummary; // Replace with proper type

  const AccountSummaryHeader({
    super.key,
    required this.amountSummary,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      pinned: true,
      expandedHeight: 200.0,
      title: Text(
        'Remind Wallet',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.only(
            top: 100,
            left: 16,
            right: 16,
            bottom: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTotalBalance(context),
              const SizedBox(height: 20),
              _buildExpenseIncomeRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBalance(BuildContext context) {
    return Text(
      '[ All Accounts Rs. ${amountSummary.currentBalance} ]',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildExpenseIncomeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SummaryItem(
          title: 'EXPENSE SO FAR',
          amount: 'Rs. ${amountSummary.totalExpenses}',
          color: AppColors.expenseColor,
        ),
        _SummaryItem(
          title: 'INCOME SO FAR',
          amount: 'Rs. ${amountSummary.totalIncome}',
          color: AppColors.incomeColor,
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const _SummaryItem({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
