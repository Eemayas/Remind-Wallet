import 'package:flutter/material.dart';
import 'package:remind_wallet/global/utils/generate_unique_id.dart';
import 'package:remind_wallet/global/widgets/add_edit_account_modal.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/models/transaction_icon.dart';

class AccountFormDialog extends StatefulWidget {
  final AccountModel? existingAccount;
  final Function(AccountModel account, bool isEdit) onAccountSaved;

  const AccountFormDialog({
    super.key,
    this.existingAccount,
    required this.onAccountSaved,
  });

  @override
  State<AccountFormDialog> createState() => _AccountFormDialogState();
}

class _AccountFormDialogState extends State<AccountFormDialog> {
  late final TextEditingController _accountNameController;
  late final TextEditingController _accountAmountController;
  late final List<TransactionIcon> _availableIcons;
  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeIcons();
  }

  void _initializeControllers() {
    _accountNameController = TextEditingController(
      text: widget.existingAccount?.name ?? '',
    );
    _accountAmountController = TextEditingController(
      text: widget.existingAccount?.currentBalance.toString() ?? '',
    );
  }

  void _initializeIcons() {
    _availableIcons = initialAccountCategoryIcons;
    _selectedIcon = widget.existingAccount != null
        ? _availableIcons[widget.existingAccount!.iconIndex ?? 0].icon
        : null;
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountAmountController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final account = AccountModel(
      id: widget.existingAccount?.id ?? generateUniqueId(),
      name: _accountNameController.text,
      currentBalance:
          (double.tryParse(_accountAmountController.text)?.toInt() ?? 0),
      iconIndex:
          _availableIcons.indexWhere((icon) => icon.icon == _selectedIcon),
    );

    widget.onAccountSaved(account, widget.existingAccount != null);
    Navigator.of(context).pop();
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AddAccountForm(
      accountName: _accountNameController,
      accountInitialAmount: _accountAmountController,
      selectedIcon: _selectedIcon,
      availableIcons: _availableIcons,
      onIconSelected: (icon) {
        setState(() {
          _selectedIcon = icon;
        });
      },
      onCancel: _handleCancel,
      onSave: _handleSave,
    );
  }
}
