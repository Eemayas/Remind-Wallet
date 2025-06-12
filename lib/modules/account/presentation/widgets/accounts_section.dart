import 'package:flutter/material.dart';
import 'package:remind_wallet/global/widgets/account_card.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/modules/account/presentation/widgets/empty_accounts_widget.dart';

class AccountsSection extends StatelessWidget {
  final List<AccountModel> accounts;
  final VoidCallback onAddAccount;
  final Function(AccountModel) onEditAccount;
  final Function(AccountModel) onDeleteAccount;

  const AccountsSection({
    super.key,
    required this.accounts,
    required this.onAddAccount,
    required this.onEditAccount,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context),
          const SizedBox(height: 16),
          _buildAccountsList(),
          const SizedBox(height: 12),
          _buildAddAccountButton(),
          const SizedBox(height: 80), // Extra space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Text(
      'Accounts',
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildAccountsList() {
    if (accounts.isEmpty) {
      return const EmptyAccountsWidget();
    }

    return Column(
      children: accounts.map((account) {
        return Column(
          children: [
            AccountCard(
              account: account,
              onEdit: () => onEditAccount(account),
              onDelete: () => onDeleteAccount(account),
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAddAccountButton() {
    return Center(
      child: CustomElevatedButton(
        onPressed: onAddAccount,
        label: 'ADD NEW ACCOUNT',
        icon: Icons.add,
      ),
    );
  }
}
