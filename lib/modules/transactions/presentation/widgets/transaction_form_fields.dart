import 'package:flutter/material.dart';
import 'package:remind_wallet/Componet/input_filed.dart';
import 'package:remind_wallet/global/widgets/option_picker_field.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/modules/transactions/logic/transaction_form_controller.dart';

class TransactionFormFields extends StatelessWidget {
  final TransactionFormController controller;
  final List<AccountModel> accounts;
  final VoidCallback onAccountPickerTap;
  final VoidCallback onCategoryPickerTap;

  const TransactionFormFields({
    super.key,
    required this.controller,
    required this.accounts,
    required this.onAccountPickerTap,
    required this.onCategoryPickerTap,
  });

  String _getDisplayAccountName() {
    if (controller.selectedAccountId == "Account") {
      return 'Account';
    }

    try {
      return accounts
          .firstWhere((account) => account.id == controller.selectedAccountId)
          .name;
    } catch (e) {
      return 'Account';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Account and Category selectors
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: BaseDropdownPickerField(
                  labelText: 'Account',
                  prefixIcon: Icons.account_balance_wallet,
                  selectedValue: _getDisplayAccountName(),
                  onTap: onAccountPickerTap,
                  hintText: 'Select an account',
                  validator: (String? value) {
                    if (value == 'Account' || value == null || value.isEmpty) {
                      return 'Please select an account';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: BaseDropdownPickerField(
                  labelText: 'Category',
                  prefixIcon: Icons.local_offer,
                  selectedValue: controller.selectedCategory,
                  onTap: onCategoryPickerTap,
                  hintText: 'Select a Category',
                  validator: (String? value) {
                    if (value == 'Category' || value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Title field
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ClearableInputField(
            hintText: "Prashant, Ram",
            controller: controller.toFromController,
            keyboardType: TextInputType.text,
            labelText: "To/From",
            prefixIcon: Icons.person_2_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a to/from person name';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 16),

        // Notes field
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ClearableInputField(
            hintText: "Add notes",
            controller: controller.notesController,
            keyboardType: TextInputType.text,
            labelText: "Notes",
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
