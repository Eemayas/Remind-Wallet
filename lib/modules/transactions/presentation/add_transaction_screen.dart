// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:remind_wallet/Componet/input_filed.dart';
// import 'package:remind_wallet/bloc/expense_bloc.dart';
// import 'package:remind_wallet/bloc/expense_event.dart';
// import 'package:remind_wallet/bloc/expense_state.dart';
// import 'package:remind_wallet/global/utils/generate_unique_id.dart';
// import 'package:remind_wallet/global/widgets/account_card.dart';
// import 'package:remind_wallet/global/widgets/account_form_dialog.dart';
// import 'package:remind_wallet/global/widgets/category_form_dialog.dart';
// import 'package:remind_wallet/global/widgets/category_option_tile.dart';
// import 'package:remind_wallet/global/widgets/custom_button.dart';
// import 'package:remind_wallet/global/widgets/date_time_picker.dart';
// import 'package:remind_wallet/global/widgets/delete_account_dialog.dart';
// import 'package:remind_wallet/global/widgets/option_picker_field.dart';
// import 'package:remind_wallet/global/widgets/transaction_tab_selector.dart';
// import 'package:remind_wallet/models/account_model.dart';
// import 'package:remind_wallet/models/category_model.dart';
// import 'package:remind_wallet/models/transaction_icon.dart';
// import 'package:remind_wallet/models/transaction_model.dart';
// import 'package:remind_wallet/modules/transactions/presentation/widgets/calculator_widget.dart';
// import 'package:remind_wallet/theme/color.dart';

// class AddTransactionsScreen extends StatefulWidget {
//   const AddTransactionsScreen({super.key});

//   @override
//   AddTransactionsScreenState createState() => AddTransactionsScreenState();
// }

// class AddTransactionsScreenState extends State<AddTransactionsScreen> {
//   String currentAmount = '0';
//   String selectedTransactionType = TransactionType.expense.name;
//   String selectedAccountId = 'Account';
//   String selectedCategory = 'Category';
//   TransactionType type = TransactionType.expense;
//   int selectedTab = 1;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();
//   final TextEditingController accountInitialAmount = TextEditingController();
//   final TextEditingController accountName = TextEditingController();

//   DateTime selectedDateTime = DateTime.now();

//   void _saveExpense() {
//     context.read<ExpenseBloc>().add(
//           AddTransactionEvent(
//             Transaction(
//               id: generateUniqueId(),
//               name: titleController.text,
//               amount: int.tryParse(currentAmount) ?? 0,
//               type: type,
//               category: selectedCategory,
//               date: selectedDateTime.toIso8601String(),
//               account: selectedAccountId,
//               person: "",
//               description: notesController.text,
//               createdDate: DateTime.now().toIso8601String(),
//             ),
//           ),
//         );

//     // Here you would typically save to database
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Expense saved: \$$currentAmount'),
//         backgroundColor: Colors.green,
//       ),
//     );

//     // Reset form
//     setState(() {
//       currentAmount = '0';
//       selectedAccountId = 'Account';
//       selectedCategory = 'Category';
//       notesController.clear();
//     });
//   }

//   void _showAddOrEditAccountForm({AccountModel? existingAccount}) {
//     showDialog(
//       context: context,
//       builder: (innerContext) => AccountFormDialog(
//         existingAccount: existingAccount,
//         onAccountSaved: (account, isEdit) {
//           final bloc = context.read<ExpenseBloc>();
//           if (isEdit) {
//             bloc.add(UpdateAccountEvent(account));
//           } else {
//             bloc.add(AddAccountEvent(account));
//           }
//         },
//       ),
//     );
//   }

//   void showDeleteAccountDialog({
//     required BuildContext context,
//     required AccountModel account,
//   }) {
//     showDialog(
//       context: context,
//       builder: (_) => DeleteAccountDialog(
//         title: 'Delete Account?',
//         content:
//             "Are you sure you want to delete? This action is irreversible.",
//         onDelete: () {
//           final bloc = context.read<ExpenseBloc>();
//           bloc.add(DeleteAccountEvent(account));
//           // Navigator.pop(context);
//         },
//       ),
//     );
//   }

//   void _showAccountPicker() {
//     final expenseBloc = BlocProvider.of<ExpenseBloc>(context);

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.bottomSheetColor,
//       builder: (_) {
//         return BlocProvider.value(
//           value: expenseBloc,
//           child: BlocConsumer<ExpenseBloc, ExpenseState>(
//             listener: _handleStateChanges,
//             builder: (blocContext, state) {
//               return Container(
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.5,
//                 ),
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         'Select Account',
//                         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ...state.accounts.map(
//                       (account) => Column(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedAccountId = account.id;
//                               });
//                               Navigator.pop(context);
//                             },
//                             child: AccountCard(
//                               account: account,
//                               onEdit: () => _showAddOrEditAccountForm(
//                                 existingAccount: account,
//                               ),
//                               onDelete: () => showDeleteAccountDialog(
//                                 context: context,
//                                 account: account,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Center(
//                       child: CustomElevatedButton(
//                         label: "Add New Account",
//                         onPressed: _showAddOrEditAccountForm,
//                         icon: Icons.add,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showAddOrEditCategoryForm({CategoryModel? existingCategory}) {
//     showDialog(
//       context: context,
//       builder: (innerContext) => CategoryFormDialog(
//         existingCategory: existingCategory,
//         onCategorySaved: (category, isEdit) {
//           final bloc = context.read<ExpenseBloc>();
//           if (isEdit) {
//             bloc.add(UpdateCategoryEvent(category));
//           } else {
//             bloc.add(AddCategoryEvent(category));
//           }
//         },
//       ),
//     );
//   }

//   void _showCategoryPicker() {
//     final expenseBloc = BlocProvider.of<ExpenseBloc>(context);
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.bottomSheetColor,
//       isScrollControlled: true,
//       builder: (_) {
//         return BlocProvider.value(
//           value: expenseBloc,
//           child: BlocConsumer<ExpenseBloc, ExpenseState>(
//             listener: _handleStateChanges,
//             builder: (context, state) {
//               return Container(
//                 height: MediaQuery.of(context).size.height * 0.8,
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         'Select a category',
//                         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Expanded(
//                       child: GridView.count(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 20,
//                         mainAxisSpacing: 20,
//                         children: state.categories.where((category) {
//                           // Filter categories based on selected tab
//                           if (selectedTab == 0 || selectedTab == 3) {
//                             return category.type == TransactionType.income;
//                           } else {
//                             return category.type == TransactionType.expense;
//                           }
//                         }).map((category) {
//                           print("Category: $category, type: $type");
//                           List<TransactionIcon> availableIcons =
//                               selectedTab == 0 || selectedTab == 3
//                                   ? initialIncomeCategoryIcons
//                                   : initialExpenseCategoryIcons;
//                           return CategoryOptionTile(
//                             name: category.name,
//                             iconData:
//                                 availableIcons[category.iconIndex ?? 0].icon,
//                             iconBackgroundColor:
//                                 availableIcons[category.iconIndex ?? 0].color,
//                             onTap: () {
//                               setState(() {
//                                 selectedCategory = category.name;
//                               });
//                               Navigator.pop(context);
//                             },
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Center(
//                       child: CustomElevatedButton(
//                         label: "Add New Category",
//                         onPressed: _showAddOrEditCategoryForm,
//                         icon: Icons.add,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _handleStateChanges(BuildContext context, ExpenseState state) {
//     if (state.status == ExpenseStatus.failure) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             state.errorMessage ?? 'An error occurred',
//             style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                   color: AppColors.errorTextColor,
//                 ),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(
//             '✕  CANCEL',
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyMedium!
//                 .copyWith(fontWeight: FontWeight.bold),
//           ),
//         ),
//         leadingWidth: 120,
//         actions: [
//           TextButton(
//             onPressed: () {
//               _saveExpense();
//             },
//             child: Text(
//               '✓  SAVE',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(fontWeight: FontWeight.bold),
//             ),
//           )
//         ],
//       ),
//       body: BlocConsumer<ExpenseBloc, ExpenseState>(
//         listener: _handleStateChanges,
//         builder: (context, state) {
//           return Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TransactionTabSelector(
//                   tabs: [
//                     TransactionType.income.name,
//                     TransactionType.expense.name,
//                     TransactionType.toPay.name,
//                     TransactionType.toReceive.name,
//                     TransactionType.transfer.name,
//                   ],
//                   selectedIndex: selectedTab,
//                   onTabSelected: (index) {
//                     setState(() {
//                       selectedTab = index;
//                     });
//                   },
//                 ),

//                 // Account and Category selectors
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: BaseDropdownPickerField(
//                           labelText: 'Account',
//                           prefixIcon: Icons.account_balance_wallet,
//                           selectedValue: selectedAccountId == "Account"
//                               ? 'Account'
//                               : state.accounts
//                                   .firstWhere(
//                                     (account) =>
//                                         account.id == selectedAccountId,
//                                   )
//                                   .name,
//                           onTap: _showAccountPicker,
//                           hintText: 'Select an account',
//                           validator: (String? value) {
//                             if (value == 'Account' ||
//                                 value == null ||
//                                 value.isEmpty) {
//                               return 'Please select an account';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: BaseDropdownPickerField(
//                           labelText: 'Category',
//                           prefixIcon: Icons.local_offer,
//                           selectedValue: selectedCategory,
//                           onTap: _showCategoryPicker,
//                           hintText: 'Select an Category',
//                           validator: (String? value) {
//                             if (value == 'Category' ||
//                                 value == null ||
//                                 value.isEmpty) {
//                               return 'Please select an account';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 SizedBox(
//                   height: 16,
//                 ),

//                 // Name section
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: ClearableInputField(
//                     hintText: "Shopping at the mall / Grocery shopping",
//                     controller: titleController,
//                     keyboardType: TextInputType.text,
//                     labelText: "Title",
//                     prefixIcon: Icons.title_sharp,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a title';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),

//                 // Notes section
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: ClearableInputField(
//                     hintText: "Add notes",
//                     controller: notesController,
//                     keyboardType: TextInputType.text,
//                     labelText: "Notes",
//                     maxLines: 2,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: CalculatorWidget(
//                       initialValue: currentAmount,
//                       onValueChanged: (value) {
//                         setState(() {
//                           currentAmount = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       persistentFooterButtons: [
//         DateTimePickerRow(
//           selectedDateTime: selectedDateTime,
//           onChanged: (newDateTime) {
//             setState(() {
//               selectedDateTime = newDateTime;
//             });
//           },
//         ),
//       ],
//     );
//   }
// }
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TransactionFormController();
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

  void _handleAccountActions(ExpenseBloc bloc) {
    // Account management methods
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

    // Show account picker
    TransactionScreenLogic.showAccountPicker(
      context: context,
      accounts: context.read<ExpenseBloc>().state.accounts,
      selectedAccountId: _controller.selectedAccountId,
      onAccountSelected: (accountId) {
        setState(() => _controller.updateAccount(accountId));
      },
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
      categories: context.read<ExpenseBloc>().state.categories,
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
                  onAccountPickerTap: () =>
                      _handleAccountActions(context.read<ExpenseBloc>()),
                  onCategoryPickerTap: () =>
                      _handleCategoryActions(context.read<ExpenseBloc>()),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CalculatorWidget(
                      initialValue: _controller.currentAmount,
                      onValueChanged: (value) {
                        setState(() => _controller.updateAmount(value));
                      },
                    ),
                  ),
                ),
              ],
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
