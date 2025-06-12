import 'package:flutter/material.dart';

class EmptyAccountsWidget extends StatelessWidget {
  const EmptyAccountsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No accounts available. Add one to get started!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
