import 'package:flutter/material.dart';
import 'package:remind_wallet/global/widgets/account_form_dialog.dart';
import 'package:remind_wallet/global/widgets/category_form_dialog.dart';
import 'package:remind_wallet/global/widgets/delete_account_dialog.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/models/category_model.dart';
import 'package:remind_wallet/modules/transactions/presentation/widgets/account_picker_bottom_sheet.dart';
import 'package:remind_wallet/modules/transactions/presentation/widgets/category_picker_bottom_sheet.dart';
import 'package:remind_wallet/theme/color.dart';

class TransactionScreenLogic {
  static void showAccountPicker({
    required BuildContext context,
    required List<AccountModel> accounts,
    required String selectedAccountId,
    required Function(String) onAccountSelected,
    required VoidCallback onAddNewAccount,
    required Function(AccountModel) onEditAccount,
    required Function(AccountModel) onDeleteAccount,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountPickerBottomSheet(
        accounts: accounts,
        selectedAccountId: selectedAccountId,
        onAccountSelected: onAccountSelected,
        onAddNewAccount: onAddNewAccount,
        onEditAccount: onEditAccount,
        onDeleteAccount: onDeleteAccount,
      ),
    );
  }

  static void showCategoryPicker({
    required BuildContext context,
    required List<CategoryModel> categories,
    required String selectedCategory,
    required int selectedTab,
    required Function(String) onCategorySelected,
    required VoidCallback onAddNewCategory,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CategoryPickerBottomSheet(
        categories: categories,
        selectedCategory: selectedCategory,
        selectedTab: selectedTab,
        onCategorySelected: onCategorySelected,
        onAddNewCategory: onAddNewCategory,
      ),
    );
  }

  static void showAccountForm({
    required BuildContext context,
    required Function(AccountModel, bool) onAccountSaved,
    AccountModel? existingAccount,
  }) {
    showDialog(
      context: context,
      builder: (innerContext) => AccountFormDialog(
        existingAccount: existingAccount,
        onAccountSaved: onAccountSaved,
      ),
    );
  }

  static void showCategoryForm({
    required BuildContext context,
    required Function(CategoryModel, bool) onCategorySaved,
    CategoryModel? existingCategory,
  }) {
    showDialog(
      context: context,
      builder: (innerContext) => CategoryFormDialog(
        existingCategory: existingCategory,
        onCategorySaved: onCategorySaved,
      ),
    );
  }

  static void showDeleteAccountDialog({
    required BuildContext context,
    required AccountModel account,
    required VoidCallback onDelete,
  }) {
    showDialog(
      context: context,
      builder: (_) => DeleteAccountDialog(
        title: 'Delete Account?',
        content:
            "Are you sure you want to delete? This action is irreversible.",
        onDelete: onDelete,
      ),
    );
  }

  static void showSuccessMessage(BuildContext context, String amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction saved: \$$amount'),
        backgroundColor: Colors.green,
      ),
    );
  }

  static void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.errorTextColor,
              ),
        ),
      ),
    );
  }
}
