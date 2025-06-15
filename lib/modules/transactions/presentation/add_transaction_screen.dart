import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_wallet/Componet/input_filed.dart';
import 'package:remind_wallet/bloc/expense_bloc.dart';
import 'package:remind_wallet/bloc/expense_event.dart';
import 'package:remind_wallet/bloc/expense_state.dart';
import 'package:remind_wallet/constant.dart';
import 'package:remind_wallet/global/utils/generate_unique_id.dart';
import 'package:remind_wallet/global/widgets/account_card.dart';
import 'package:remind_wallet/global/widgets/account_form_dialog.dart';
import 'package:remind_wallet/global/widgets/category_option_tile.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/global/widgets/date_time_picker.dart';
import 'package:remind_wallet/global/widgets/delete_account_dialog.dart';
import 'package:remind_wallet/global/widgets/option_picker_field.dart';
import 'package:remind_wallet/global/widgets/transaction_tab_selector.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/models/transaction_icon.dart';
import 'package:remind_wallet/models/transaction_model.dart';
import 'package:remind_wallet/theme/color.dart';
import 'package:remind_wallet/theme/typography.dart';

class Category {
  final String name;
  final TransactionIcon icon;

  Category({required this.name, required this.icon});
}

class AddTransactionsScreen extends StatefulWidget {
  const AddTransactionsScreen({super.key});

  @override
  AddTransactionsScreenState createState() => AddTransactionsScreenState();
}

class AddTransactionsScreenState extends State<AddTransactionsScreen> {
  String currentAmount = '0';
  String selectedTransactionType = TransactionType.expense.name;
  String selectedAccountId = 'Account';
  String selectedCategory = 'Category';
  TransactionType type = TransactionType.expense;
  int selectedTab = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController accountInitialAmount = TextEditingController();
  final TextEditingController accountName = TextEditingController();

  DateTime selectedDateTime = DateTime.now();

  void _onNumberPressed(String number) {
    setState(() {
      if (currentAmount == '0') {
        currentAmount = number;
      } else {
        currentAmount += number;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      if (operator == '+' ||
          operator == '-' ||
          operator == 'x' ||
          operator == '÷') {
        if (!currentAmount.endsWith('+') &&
            !currentAmount.endsWith('-') &&
            !currentAmount.endsWith('x') &&
            !currentAmount.endsWith('÷')) {
          currentAmount += operator;
        }
      } else if (operator == '=') {
        _calculateResult();
      } else if (operator == '.') {
        if (!currentAmount.contains('.')) {
          currentAmount += '.';
        }
      }
    });
  }

  void _calculateResult() {
    try {
      String expression =
          currentAmount.replaceAll('x', '*').replaceAll('÷', '/');

      // Simple calculation for basic operations
      double result = _evaluateExpression(expression);
      setState(() {
        currentAmount = result.toString();
      });
    } catch (e) {
      setState(() {
        currentAmount = 'Error';
      });
    }
  }

  double _evaluateExpression(String expression) {
    // Simple expression evaluator for basic operations
    List<String> tokens = [];
    String currentToken = '';

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if (char == '+' || char == '-' || char == '*' || char == '/') {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken);
          currentToken = '';
        }
        tokens.add(char);
      } else {
        currentToken += char;
      }
    }
    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }

    // Simple left-to-right evaluation
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double operand = double.parse(tokens[i + 1]);

      switch (operator) {
        case '+':
          result += operand;
          break;
        case '-':
          result -= operand;
          break;
        case '*':
          result *= operand;
          break;
        case '/':
          result /= operand;
          break;
      }
    }
    return result;
  }

  void _deleteLastDigit() {
    setState(() {
      if (currentAmount.length > 1) {
        currentAmount = currentAmount.substring(0, currentAmount.length - 1);
      } else {
        currentAmount = '0';
      }
    });
  }

  void _saveExpense() {
    context.read<ExpenseBloc>().add(
          AddTransactionEvent(
            Transaction(
              id: generateUniqueId(),
              name: titleController.text,
              amount: int.tryParse(currentAmount) ?? 0,
              type: type,
              category: selectedCategory,
              date: selectedDateTime.toIso8601String(),
              account: selectedAccountId,
              person: "",
              description: notesController.text,
              createdDate: DateTime.now().toIso8601String(),
            ),
          ),
        );

    // Here you would typically save to database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Expense saved: \$$currentAmount'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset form
    setState(() {
      currentAmount = '0';
      selectedAccountId = 'Account';
      selectedCategory = 'Category';
      notesController.clear();
    });
  }

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

  void _showAccountPicker() {
    final expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bottomSheetColor,
      builder: (_) {
        return BlocProvider.value(
          value: expenseBloc,
          child: BlocConsumer<ExpenseBloc, ExpenseState>(
            listener: _handleStateChanges,
            builder: (blocContext, state) {
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                padding: EdgeInsets.all(20),
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
                    ...state.accounts.map(
                      (account) => Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAccountId = account.id;
                              });
                              Navigator.pop(context);
                            },
                            child: AccountCard(
                              account: account,
                              onEdit: () => _showAddOrEditAccountForm(
                                existingAccount: account,
                              ),
                              onDelete: () => showDeleteAccountDialog(
                                context: context,
                                account: account,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: CustomElevatedButton(
                        label: "Add New Account",
                        onPressed: _showAddOrEditAccountForm,
                        icon: Icons.add,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showAddCategoryForm() {
    final TextEditingController categoryNameController =
        TextEditingController();

    final List<TransactionIcon> incomeIcons = initialExpenseCategoryIcons;

    final List<TransactionIcon> expenseIcons = initialIncomeCategoryIcons;

    final List<TransactionIcon> availableIcons =
        selectedTransactionType == TransactionType.income.name ||
                selectedTransactionType == TransactionType.toReceive.name
            ? incomeIcons
            : expenseIcons;

    IconData? selectedIcon;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.bottomSheetColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              titlePadding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add New Category',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.white24,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClearableInputField(
                      hintText: "Category Name",
                      controller: categoryNameController,
                      keyboardType: TextInputType.text,
                      labelText: "Category Name",
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Pick an Icon",
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputFillColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(8),
                      height: 177,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            (availableIcons.length / 2).ceil(),
                            (colIndex) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Column(
                                  children: List.generate(2, (rowIndex) {
                                    int index = colIndex * 2 + rowIndex;
                                    if (index >= availableIcons.length) {
                                      return SizedBox();
                                    }
                                    IconData icon = availableIcons[index].icon;
                                    Color iconColor =
                                        availableIcons[index].color;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0),
                                      child: CategoryOptionTile(
                                        iconData: icon,
                                        iconBackgroundColor: iconColor,
                                        isLabelVisible: false,
                                        containerColor: selectedIcon == icon
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withAlpha((0.5 * 255).round())
                                            : Colors.transparent,
                                        onTap: () {
                                          setState(() => selectedIcon = icon);
                                        },
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                CustomElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedIcon = null;
                      categoryNameController.clear();
                    });
                    Navigator.pop(context);
                  },
                  icon: Icons.cancel,
                  label: 'Cancel',
                ),
                CustomElevatedButton(
                  onPressed: () {
                    if (categoryNameController.text.isNotEmpty &&
                        selectedIcon != null) {
                      // Add logic to store the new category
                      Navigator.pop(context);
                    }
                  },
                  icon: Icons.check,
                  label: 'Save',
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCategoryPicker() {
    final List<Category> categories = [
      Category(
        name: 'Baby',
        icon: TransactionIcon(
          icon: Icons.baby_changing_station,
          color: Colors.brown,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Beauty',
        icon: TransactionIcon(
          icon: Icons.spa,
          color: Colors.pink,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Bills',
        icon: TransactionIcon(
          icon: Icons.receipt,
          color: Colors.grey,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Car',
        icon: TransactionIcon(
          icon: Icons.directions_car,
          color: Colors.purple,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Clothing',
        icon: TransactionIcon(
          icon: Icons.checkroom,
          color: Colors.orange,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Education',
        icon: TransactionIcon(
          icon: Icons.school,
          color: Colors.blue,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Electronics',
        icon: TransactionIcon(
          icon: Icons.devices,
          color: Colors.teal,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Entertainment',
        icon: TransactionIcon(
          icon: Icons.movie,
          color: Colors.indigo,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Food',
        icon: TransactionIcon(
          icon: Icons.restaurant,
          color: Colors.red,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Health',
        icon: TransactionIcon(
          icon: Icons.favorite,
          color: Colors.deepOrange,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Home',
        icon: TransactionIcon(
          icon: Icons.home,
          color: Colors.pinkAccent,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Insurance',
        icon: TransactionIcon(
          icon: Icons.verified_user,
          color: Colors.orangeAccent,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Shopping',
        icon: TransactionIcon(
          icon: Icons.shopping_cart,
          color: Colors.blue,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Social',
        icon: TransactionIcon(
          icon: Icons.group,
          color: Colors.green,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Sport',
        icon: TransactionIcon(
          icon: Icons.sports_tennis,
          color: Colors.lightGreen,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Tax',
        icon: TransactionIcon(
          icon: Icons.request_quote,
          color: Colors.deepOrange,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'Telephone',
        icon: TransactionIcon(
          icon: Icons.phone,
          color: Colors.lime,
          type: TransactionType.expense,
        ),
      ),
      Category(
        name: 'To Receive',
        icon: TransactionIcon(
          icon: Icons.attach_money,
          color: Colors.blueAccent,
          type: TransactionType.income,
        ),
      ),
      Category(
        name: 'Transportation',
        icon: TransactionIcon(
          icon: Icons.directions_bus,
          color: Colors.indigo,
          type: TransactionType.expense,
        ),
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bottomSheetColor,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Select a category',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: categories.map((category) {
                    return CategoryOptionTile(
                      name: category.name,
                      iconData: category.icon.icon,
                      iconBackgroundColor: category.icon.color,
                      onTap: () {
                        setState(() {
                          selectedCategory = category.name;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: CustomElevatedButton(
                  label: "Add New Category",
                  onPressed: _showAddCategoryForm,
                  icon: Icons.add,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalculatorRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((label) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: _buildCalculatorButton(
              label,
              onPressed: () {
                if (label == '+' ||
                    label == '-' ||
                    label == 'x' ||
                    label == '÷' ||
                    label == '=' ||
                    label == '.') {
                  _onOperatorPressed(label);
                } else {
                  _onNumberPressed(label);
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculatorButton(
    String text, {
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.inputFillColor,
        padding: EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.inputBorderColor),
        ),
      ),
      child: Text(text, style: kwhiteTextStyle.copyWith(fontSize: 20)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '✕  CANCEL',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        leadingWidth: 120,
        actions: [
          TextButton(
            onPressed: () {
              _saveExpense();
            },
            child: Text(
              '✓  SAVE',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return Form(
            key: _formKey,
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
                  selectedIndex: selectedTab,
                  onTabSelected: (index) {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                ),

                // Account and Category selectors
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: BaseDropdownPickerField(
                          labelText: 'Account',
                          prefixIcon: Icons.account_balance_wallet,
                          selectedValue: selectedAccountId == "Account"
                              ? 'Account'
                              : state.accounts
                                  .firstWhere(
                                    (account) =>
                                        account.id == selectedAccountId,
                                  )
                                  .name,
                          onTap: _showAccountPicker,
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
                          selectedValue: selectedCategory,
                          onTap: _showCategoryPicker,
                          hintText: 'Select an Category',
                          validator: (String? value) {
                            if (value == 'Category' ||
                                value == null ||
                                value.isEmpty) {
                              return 'Please select an account';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                // Name section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ClearableInputField(
                    hintText: "Shopping at the mall / Grocery shopping",
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    labelText: "Title",
                    prefixIcon: Icons.title_sharp,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                // Notes section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ClearableInputField(
                    hintText: "Add notes",
                    controller: notesController,
                    keyboardType: TextInputType.text,
                    labelText: "Notes",
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                // Amount display
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.inputFillColor,
                      border: Border.all(color: AppColors.inputBorderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            currentAmount.toString(),
                            style: AppTextStyles.headlineLarge,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: _deleteLastDigit,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.backspace_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                // Calculator grid
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      spacing: 5,
                      children: [
                        _buildCalculatorRow(['+', '7', '8', '9']),
                        _buildCalculatorRow(['-', '4', '5', '6']),
                        _buildCalculatorRow(['x', '1', '2', '3']),
                        _buildCalculatorRow(['÷', '0', '.', '=']),
                      ],
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
          selectedDateTime: selectedDateTime,
          onChanged: (newDateTime) {
            setState(() {
              selectedDateTime = newDateTime;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min, // ⬅️ Only take space needed
        children: [
          if (isSelected)
            Icon(Icons.check_circle,
                color: AppColors.optionSelectedColor, size: 15),
          if (isSelected) SizedBox(width: 5),
          Text(
            // Convert camelCase or lowerCamelCase to ALL CAPS with spaces
            title
                .replaceAllMapped(
                  RegExp(r'([a-z])([A-Z])'),
                  (match) => '${match.group(1)} ${match.group(2)}',
                )
                .toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(
        width: 1,
        height: 20,
        color: Colors.grey.withOpacity(0.3),
      );
}
