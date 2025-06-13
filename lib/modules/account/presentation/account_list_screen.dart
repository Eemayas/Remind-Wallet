// account_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_wallet/bloc/expense_bloc.dart';
import 'package:remind_wallet/bloc/expense_event.dart';
import 'package:remind_wallet/bloc/expense_state.dart';
import 'package:remind_wallet/global/widgets/delete_account_dialog.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/global/widgets/account_form_dialog.dart';
import 'package:remind_wallet/modules/account/presentation/widgets/account_summary_header.dart';
import 'package:remind_wallet/modules/account/presentation/widgets/accounts_section.dart';
import 'package:remind_wallet/repositories/expense_repository.dart';
import 'package:remind_wallet/theme/color.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  HiveExpenseRepository expRepo = HiveExpenseRepository();

  // @override
  // void initState() {
  //   super.initState();
  //   expRepo.deleteAllData();
  // }

  void _showAddOrEditAccountForm({AccountModel? existingAccount}) {
    showDialog(
      context: context,
      builder: (innerContext) => AccountFormDialog(
        existingAccount: existingAccount,
        onAccountSaved: (account, isEdit) {
          final bloc = context.read<ExpenseBloc>();
          if (isEdit) {
            bloc.add(UpdateAccountEvent(account));
          } else {
            bloc.add(AddAccountEvent(account));
          }
        },
      ),
    );
  }

  void showDeleteAccountDialog({
    required BuildContext context,
    required AccountModel account,
  }) {
    showDialog(
      context: context,
      builder: (_) => DeleteAccountDialog(
        title: 'Delete Account?',
        content:
            "Are you sure you want to delete? This action is irreversible.",
        onDelete: () {
          final bloc = context.read<ExpenseBloc>();
          bloc.add(DeleteAccountEvent(account));
          // Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state.status == ExpenseStatus.loading) {
            return const _LoadingWidget();
          }

          if (state.status == ExpenseStatus.initial) {
            return const _InitialWidget();
          }

          return _buildMainContent(state);
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ExpenseState state) {
    if (state.status == ExpenseStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'An error occurred',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.errorTextColor,
                ),
          ),
        ),
      );
    }
  }

  Widget _buildMainContent(ExpenseState state) {
    return CustomScrollView(
      slivers: [
        AccountSummaryHeader(amountSummary: state.amountSummary),
        SliverToBoxAdapter(
          child: AccountsSection(
            accounts: state.accounts,
            onAddAccount: () => _showAddOrEditAccountForm(),
            onEditAccount: (account) => _showAddOrEditAccountForm(
              existingAccount: account,
            ),
            onDeleteAccount: (account) {
              showDeleteAccountDialog(
                context: context,
                account: account,
              );
            },
          ),
        ),
      ],
    );
  }
}

// Private widgets for this screen
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFFFD700),
      ),
    );
  }
}

class _InitialWidget extends StatelessWidget {
  const _InitialWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Welcome to Remind Wallet',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
