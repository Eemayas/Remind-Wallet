// account_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_wallet/bloc/expense_bloc.dart';
import 'package:remind_wallet/bloc/expense_event.dart';
import 'package:remind_wallet/bloc/expense_state.dart';
import 'package:remind_wallet/global/widgets/account_card.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/modules/account/widgets/account_form_dialog.dart';
import 'package:remind_wallet/modules/account/widgets/empty_accounts_widget.dart';
import 'package:remind_wallet/theme/color.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  // HiveExpenseRepository expRepo = HiveExpenseRepository();

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
              // TODO: Implement delete functionality
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

// ================================
// widgets/account_summary_header.dart
// ================================

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

// ================================
// widgets/accounts_section.dart
// ================================

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

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:remind_wallet/bloc/expense_bloc.dart';
// import 'package:remind_wallet/bloc/expense_event.dart';
// import 'package:remind_wallet/bloc/expense_state.dart';
// import 'package:remind_wallet/global/utils/generate_unique_id.dart';
// import 'package:remind_wallet/global/widgets/account_card.dart';
// import 'package:remind_wallet/global/widgets/add_edit_account_modal.dart';
// import 'package:remind_wallet/global/widgets/custom_button.dart';
// import 'package:remind_wallet/models/account_model.dart';
// import 'package:remind_wallet/models/transaction_icon.dart';
// import 'package:remind_wallet/theme/color.dart';

// class AccountListScreen extends StatefulWidget {
//   const AccountListScreen({super.key});

//   @override
//   State<AccountListScreen> createState() => _AccountListScreenState();
// }

// class _AccountListScreenState extends State<AccountListScreen> {
//   void showAddOrEditAccountForm(
//     BuildContext context, {
//     AccountModel? existingAccount,
//   }) {
//     final TextEditingController accountName =
//         TextEditingController(text: existingAccount?.name ?? '');
//     final TextEditingController accountInitialAmount = TextEditingController(
//         text: existingAccount?.currentBalance.toString() ?? '');
//     final List<TransactionIcon> availableIcons = accountIcons;

//     IconData? selectedIcon = existingAccount != null
//         ? availableIcons[existingAccount.iconIndex ?? 0].icon
//         : null;

//     final bool isEdit = existingAccount != null;

//     showDialog(
//       context: context,
//       builder: (innerContext) {
//         return StatefulBuilder(
//           builder: (innerContext, setState) {
//             return AddAccountForm(
//               accountName: accountName,
//               accountInitialAmount: accountInitialAmount,
//               selectedIcon: selectedIcon,
//               availableIcons: availableIcons,
//               onIconSelected: (icon) {
//                 setState(() {
//                   selectedIcon = icon;
//                 });
//               },
//               onCancel: () {
//                 selectedIcon = null;
//                 accountName.clear();
//                 accountInitialAmount.clear();
//                 Navigator.pop(innerContext);
//               },
//               onSave: () {
//                 final updatedAccount = AccountModel(
//                   id: existingAccount?.id ?? generateUniqueId(),
//                   name: accountName.text,
//                   currentBalance:
//                       (double.tryParse(accountInitialAmount.text)?.toInt() ??
//                           0),
//                   iconIndex: availableIcons
//                       .indexWhere((icon) => icon.icon == selectedIcon),
//                 );

//                 final bloc = context.read<ExpenseBloc>();

//                 if (isEdit) {
//                   bloc.add(UpdateAccountEvent(updatedAccount));
//                 } else {
//                   bloc.add(AddAccountEvent(updatedAccount));
//                 }

//                 selectedIcon = null;
//                 accountName.clear();
//                 accountInitialAmount.clear();
//                 Navigator.pop(innerContext);
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<ExpenseBloc, ExpenseState>(
//         listener: (context, state) {
//           if (state.status == ExpenseStatus.failure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   state.errorMessage ?? 'An error occurred',
//                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                         color: AppColors.errorTextColor,
//                       ),
//                 ),
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state.status == ExpenseStatus.loading) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFFFFD700),
//               ),
//             );
//           }

//           if (state.status == ExpenseStatus.initial) {
//             return Center(
//               child: Text(
//                 'Welcome to Remind Wallet',
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }
//           return CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 elevation: 0,
//                 pinned: true,
//                 expandedHeight: 200.0,
//                 title: Text(
//                   'Remind Wallet',
//                   style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 actions: [],
//                 flexibleSpace: FlexibleSpaceBar(
//                   background: Container(
//                     padding: EdgeInsets.only(
//                         top: 100, left: 16, right: 16, bottom: 20),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           '[ All Accounts Rs. ${state.amountSummary.currentBalance} ]',
//                           style:
//                               Theme.of(context).textTheme.titleMedium!.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                         ),
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Column(
//                               children: [
//                                 Text(
//                                   'EXPENSE SO FAR',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium!
//                                       .copyWith(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   'Rs. ${state.amountSummary.totalExpenses}',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium!
//                                       .copyWith(
//                                         color: AppColors.expenseColor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Text(
//                                   'INCOME SO FAR',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium!
//                                       .copyWith(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   'Rs. ${state.amountSummary.totalIncome}',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium!
//                                       .copyWith(
//                                         color: AppColors.incomeColor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // Accounts Section
//               SliverToBoxAdapter(
//                 child: Container(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Accounts',
//                         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                       SizedBox(height: 16),
//                       if (state.accounts.isEmpty)
//                         Center(
//                           child: Column(
//                             children: [
//                               Icon(
//                                 Icons.account_balance_wallet_outlined,
//                                 size: 64,
//                                 color: Colors.grey[400],
//                               ),
//                               SizedBox(height: 12),
//                               Text(
//                                 'No accounts available. Add one to get started!',
//                                 style: Theme.of(context).textTheme.bodyMedium,
//                               ),
//                             ],
//                           ),
//                         ),

//                       ...state.accounts.map((account) => Column(
//                             children: [
//                               AccountCard(
//                                 account: account,
//                                 onEdit: () {
//                                   showAddOrEditAccountForm(
//                                     context,
//                                     existingAccount: account,
//                                   );
//                                 },
//                                 onDelete: () {},
//                               ),
//                               SizedBox(height: 12),
//                             ],
//                           )),
//                       SizedBox(height: 12),

//                       // Add New Account Button
//                       Builder(
//                         builder: (context) {
//                           return Center(
//                             child: CustomElevatedButton(
//                               onPressed: () {
//                                 showAddOrEditAccountForm(
//                                   context,
//                                 );
//                               },
//                               label: 'ADD NEW ACCOUNT',
//                               icon: Icons.add,
//                             ),
//                           );
//                         },
//                       ),

//                       SizedBox(height: 80), // Extra space for bottom navigation
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),

//       // // Floating Action Button
//       // floatingActionButton: Container(
//       //   width: 56,
//       //   height: 56,
//       //   decoration: BoxDecoration(
//       //     color: Color(0xFF4C4C4C),
//       //     shape: BoxShape.circle,
//       //   ),
//       //   child: FloatingActionButton(
//       //     onPressed: () {},
//       //     backgroundColor: Colors.transparent,
//       //     elevation: 0,
//       //     child: Icon(
//       //       Icons.add,
//       //       color: Color(0xFFFFD700),
//       //       size: 28,
//       //     ),
//       //   ),
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }

// class BottomNavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;

//   const BottomNavItem({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.isSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           icon,
//           color: isSelected ? Color(0xFFFFD700) : Colors.grey,
//           size: 24,
//         ),
//         SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Color(0xFFFFD700) : Colors.grey,
//             fontSize: 10,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }
