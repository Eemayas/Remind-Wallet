import 'package:flutter/material.dart';
import 'package:remind_wallet/global/widgets/account_card.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/theme/color.dart';

class AccountPickerBottomSheet extends StatelessWidget {
  final List<AccountModel> accounts;
  final String selectedAccountId;
  final Function(String) onAccountSelected;
  final VoidCallback onAddNewAccount;
  final Function(AccountModel) onEditAccount;
  final Function(AccountModel) onDeleteAccount;

  const AccountPickerBottomSheet({
    super.key,
    required this.accounts,
    required this.selectedAccountId,
    required this.onAccountSelected,
    required this.onAddNewAccount,
    required this.onEditAccount,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bottomSheetColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Select Account',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: accounts.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final account = accounts[index];
                return GestureDetector(
                  onTap: () {
                    onAccountSelected(account.id);
                    Navigator.pop(context);
                  },
                  child: AccountCard(
                    account: account,
                    onEdit: () => onEditAccount(account),
                    onDelete: () => onDeleteAccount(account),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: CustomElevatedButton(
              label: "Add New Account",
              onPressed: onAddNewAccount,
              icon: Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
