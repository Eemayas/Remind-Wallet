import 'package:flutter/material.dart';
import 'package:remind_wallet/Componet/input_filed.dart';
import 'package:remind_wallet/global/widgets/option_picker_field.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/modules/transactions/logic/transaction_form_controller.dart';

class TransactionFormFields extends StatelessWidget {
  final TransactionFormController controller;
  final List<AccountModel> accounts;
  final VoidCallback onAccountPickerTap;
  final VoidCallback onToAccountPickerTap;
  final VoidCallback onCategoryPickerTap;

  const TransactionFormFields({
    super.key,
    required this.controller,
    required this.accounts,
    required this.onAccountPickerTap,
    required this.onToAccountPickerTap,
    required this.onCategoryPickerTap,
  });

  String _getDisplayAccountName({required String accountId}) {
    if (accountId == "Account") {
      return 'Account';
    }

    try {
      return accounts.firstWhere((account) => account.id == accountId).name;
    } catch (e) {
      return 'Account';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Account and Category selectors
        controller.selectedTab == 4
            ? // If the selected tab is not 4, show the account and category fields
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: BaseDropdownPickerField(
                        labelText: ' From:',
                        prefixIcon: Icons.account_balance_wallet,
                        selectedValue: _getDisplayAccountName(
                            accountId: controller.selectedAccountId),
                        onTap: onAccountPickerTap,
                        hintText: 'Select an From account',
                        validator: (String? value) {
                          if (value == 'Account' ||
                              value == null ||
                              value.isEmpty) {
                            return 'Please select an account';
                          }
                          if (controller.selectedAccountId ==
                              controller.selectedToAccountId) {
                            return 'From and To accounts cannot be the same';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: BaseDropdownPickerField(
                        labelText: 'To:',
                        prefixIcon: Icons.account_balance_wallet,
                        selectedValue: _getDisplayAccountName(
                            accountId: controller.selectedToAccountId),
                        onTap: onToAccountPickerTap,
                        hintText: 'Select an To account',
                        validator: (String? value) {
                          if (value == 'Account' ||
                              value == null ||
                              value.isEmpty) {
                            return 'Please select an account';
                          }

                          if (controller.selectedAccountId ==
                              controller.selectedToAccountId) {
                            return 'From and To accounts cannot be the same';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: BaseDropdownPickerField(
                        labelText: 'Account',
                        prefixIcon: Icons.account_balance_wallet,
                        selectedValue: _getDisplayAccountName(
                            accountId: controller.selectedAccountId),
                        onTap: onAccountPickerTap,
                        hintText: 'Select an account',
                        validator: (String? value) {
                          if (value == 'Account' ||
                              value == null ||
                              value.isEmpty) {
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
                          if (value == 'Category' ||
                              value == null ||
                              value.isEmpty) {
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
