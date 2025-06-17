import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_wallet/bloc/expense_bloc.dart';
import 'package:remind_wallet/bloc/expense_event.dart';
import 'package:remind_wallet/bloc/expense_state.dart';
import 'package:remind_wallet/global/widgets/date_time_picker.dart';
import 'package:remind_wallet/global/widgets/transaction_tab_selector.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/models/category_model.dart';
import 'package:remind_wallet/models/transaction_model.dart';
import 'package:remind_wallet/modules/transactions/logic/transaction_form_controller.dart';
import 'package:remind_wallet/modules/transactions/logic/transaction_screen_logic.dart';
import 'package:remind_wallet/modules/transactions/presentation/widgets/calculator_widget.dart';
import 'package:remind_wallet/modules/transactions/presentation/widgets/transaction_app_bar.dart';
import 'package:remind_wallet/modules/transactions/presentation/widgets/transaction_form_fields.dart';

class AddTransactionsScreen extends StatefulWidget {
  const AddTransactionsScreen({super.key});

  @override
  AddTransactionsScreenState createState() => AddTransactionsScreenState();
}

class AddTransactionsScreenState extends State<AddTransactionsScreen> {
  late final TransactionFormController _controller;
  late final ExpenseBloc expenseBloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TransactionFormController();
    expenseBloc = BlocProvider.of<ExpenseBloc>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    if (!_controller.validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final transaction = _controller.createTransaction();

      context.read<ExpenseBloc>().add(AddTransactionEvent(transaction));

      TransactionScreenLogic.showSuccessMessage(
          context, _controller.currentAmount);
      _controller.resetForm();
    } catch (e) {
      TransactionScreenLogic.showErrorMessage(
          context, 'Failed to save transaction');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleAccountPickerActions({
    required ExpenseBloc bloc,
    required String selectedAccountId,
    required void Function(String accountId) onAccountSelected,
  }) {
    void onAccountSaved(AccountModel account, bool isEdit) {
      if (isEdit) {
        bloc.add(UpdateAccountEvent(account));
      } else {
        bloc.add(AddAccountEvent(account));
      }
    }

    void onEditAccount(AccountModel account) {
      TransactionScreenLogic.showAccountForm(
        context: context,
        onAccountSaved: onAccountSaved,
        existingAccount: account,
      );
    }

    void onDeleteAccount(AccountModel account) {
      TransactionScreenLogic.showDeleteAccountDialog(
        context: context,
        account: account,
        onDelete: () => bloc.add(DeleteAccountEvent(account)),
      );
    }

    void onAddNewAccount() {
      TransactionScreenLogic.showAccountForm(
        context: context,
        onAccountSaved: onAccountSaved,
      );
    }

    TransactionScreenLogic.showAccountPicker(
      context: context,
      selectedAccountId: selectedAccountId,
      onAccountSelected: onAccountSelected,
      onAddNewAccount: onAddNewAccount,
      onEditAccount: onEditAccount,
      onDeleteAccount: onDeleteAccount,
    );
  }

  void _handleCategoryActions(ExpenseBloc bloc) {
    void onCategorySaved(CategoryModel category, bool isEdit) {
      if (isEdit) {
        bloc.add(UpdateCategoryEvent(category));
      } else {
        bloc.add(AddCategoryEvent(category));
      }
    }

    void onAddNewCategory() {
      TransactionScreenLogic.showCategoryForm(
        context: context,
        onCategorySaved: onCategorySaved,
      );
    }

    TransactionScreenLogic.showCategoryPicker(
      context: context,
      selectedCategory: _controller.selectedCategory,
      selectedTab: _controller.selectedTab,
      onCategorySelected: (category) {
        setState(() => _controller.updateCategory(category));
      },
      onAddNewCategory: onAddNewCategory,
    );
  }

  void _handleStateChanges(BuildContext context, ExpenseState state) {
    if (state.status == ExpenseStatus.failure) {
      TransactionScreenLogic.showErrorMessage(
        context,
        state.errorMessage ?? 'An error occurred',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransactionAppBar(
        onCancel: () => Navigator.pop(context),
        onSave: _saveTransaction,
        isLoading: _isLoading,
      ),
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return Form(
            key: _controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TransactionTabSelector(
                    tabs: [
                      TransactionType.income.name,
                      TransactionType.expense.name,
                      TransactionType.toPay.name,
                      TransactionType.toReceive.name,
                      TransactionType.transfer.name,
                    ],
                    selectedIndex: _controller.selectedTab,
                    onTabSelected: (index) {
                      setState(() => _controller.updateSelectedTab(index));
                    },
                  ),
                  TransactionFormFields(
                    controller: _controller,
                    accounts: state.accounts,
                    onAccountPickerTap: () => _handleAccountPickerActions(
                      bloc: context.read<ExpenseBloc>(),
                      selectedAccountId: _controller.selectedAccountId,
                      onAccountSelected: (accountId) {
                        setState(() => _controller.updateAccount(accountId));
                      },
                    ),
                    onToAccountPickerTap: () => _handleAccountPickerActions(
                      bloc: context.read<ExpenseBloc>(),
                      selectedAccountId: _controller.selectedToAccountId,
                      onAccountSelected: (accountId) {
                        setState(() => _controller.updateToAccount(accountId));
                      },
                    ),
                    onCategoryPickerTap: () =>
                        _handleCategoryActions(context.read<ExpenseBloc>()),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CalculatorWidget(
                      initialValue: _controller.currentAmount,
                      onValueChanged: (value) {
                        setState(() => _controller.updateAmount(value));
                      },
                      validator: (String? value) {
                        if (value == 0.toString() ||
                            value == null ||
                            value.isEmpty) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      persistentFooterButtons: [
        DateTimePickerRow(
          selectedDateTime: _controller.selectedDateTime,
          onChanged: (newDateTime) {
            setState(() => _controller.updateDateTime(newDateTime));
          },
        ),
      ],
    );
  }
}
