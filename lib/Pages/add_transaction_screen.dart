import 'package:flutter/material.dart';
import 'package:remind_wallet/Componet/input_filed.dart';
import 'package:remind_wallet/constant.dart';
import 'package:remind_wallet/global/widgets/category_option_tile.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/global/widgets/option_picker_field.dart';
import 'package:remind_wallet/model/TransactionIcon.dart';
import 'package:remind_wallet/theme/color.dart';

class Category {
  final String name;
  final TransactionIcon icon;

  Category({required this.name, required this.icon});
}

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ExpenseScreenState createState() => ExpenseScreenState();
}

class ExpenseScreenState extends State<ExpenseScreen> {
  String currentAmount = '0';
  String selectedAccount = 'Account';
  String selectedCategory = 'Category';
  String notes = '';
  int selectedTab = 1;

  final TextEditingController notesController = TextEditingController();

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

  void _clearAmount() {
    setState(() {
      currentAmount = '0';
    });
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
      selectedAccount = 'Account';
      selectedCategory = 'Category';
      notes = '';
      notesController.clear();
    });
  }

  void _showAccountPicker() {
    Map<String, double> accounts = {
      'Cash': 1200.0,
      'Bank Account': 5400.25,
      'Credit Card': -350.75,
      'Savings': 2000.0,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF3D3D3D),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ...accounts.entries.map(
                (entry) => ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: TextStyle(color: Colors.white)),
                      Text(
                        '\$${entry.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: entry.value >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      selectedAccount = entry.key;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddCategoryForm() {
    final TextEditingController categoryNameController =
        TextEditingController();

    final List<TransactionIcon> incomeIcons = dummyIcons
        .where((icon) => icon.type == TransactionType.income)
        .toList();

    final List<TransactionIcon> expenseIcons = dummyIcons
        .where((icon) => icon.type == TransactionType.expenses)
        .toList();

    final List<TransactionIcon> availableIcons = incomeIcons;

    IconData? selectedIcon;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF3D3D3D),
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
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Beauty',
        icon: TransactionIcon(
          icon: Icons.spa,
          color: Colors.pink,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Bills',
        icon: TransactionIcon(
          icon: Icons.receipt,
          color: Colors.grey,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Car',
        icon: TransactionIcon(
          icon: Icons.directions_car,
          color: Colors.purple,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Clothing',
        icon: TransactionIcon(
          icon: Icons.checkroom,
          color: Colors.orange,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Education',
        icon: TransactionIcon(
          icon: Icons.school,
          color: Colors.blue,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Electronics',
        icon: TransactionIcon(
          icon: Icons.devices,
          color: Colors.teal,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Entertainment',
        icon: TransactionIcon(
          icon: Icons.movie,
          color: Colors.indigo,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Food',
        icon: TransactionIcon(
          icon: Icons.restaurant,
          color: Colors.red,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Health',
        icon: TransactionIcon(
          icon: Icons.favorite,
          color: Colors.deepOrange,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Home',
        icon: TransactionIcon(
          icon: Icons.home,
          color: Colors.pinkAccent,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Insurance',
        icon: TransactionIcon(
          icon: Icons.verified_user,
          color: Colors.orangeAccent,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Shopping',
        icon: TransactionIcon(
          icon: Icons.shopping_cart,
          color: Colors.blue,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Social',
        icon: TransactionIcon(
          icon: Icons.group,
          color: Colors.green,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Sport',
        icon: TransactionIcon(
          icon: Icons.sports_tennis,
          color: Colors.lightGreen,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Tax',
        icon: TransactionIcon(
          icon: Icons.request_quote,
          color: Colors.deepOrange,
          type: TransactionType.expenses,
        ),
      ),
      Category(
        name: 'Telephone',
        icon: TransactionIcon(
          icon: Icons.phone,
          color: Colors.lime,
          type: TransactionType.expenses,
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
          type: TransactionType.expenses,
        ),
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardColor,
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

  // Widget _buildCalculatorButton(
  //   String text, {
  //   Color? color,
  //   VoidCallback? onPressed,
  // }) {
  //   return Expanded(
  //     child: Container(
  //       margin: EdgeInsets.all(4),
  //       child: ElevatedButton(
  //         onPressed: onPressed,
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: color ?? Color(0xFF4D4D4D),
  //           foregroundColor: Colors.white,
  //           padding: EdgeInsets.all(20),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //         ),
  //         child: Text(
  //           text,
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
        backgroundColor: kBackgroundColorCard,
        padding: EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey),
        ),
      ),
      child: Text(text, style: kwhiteTextStyle.copyWith(fontSize: 20)),
    );
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
            onPressed: _saveExpense,
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
      body: Column(
        children: [
          // Tab selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // ⬅️ Equal space between tabs
              children: [
                _buildTab('INCOME', 0),
                _buildDivider(),
                _buildTab('EXPENSE', 1),
                _buildDivider(),
                _buildTab('TO PAY', 3),
                _buildDivider(),
                _buildTab('TO RECEIVE', 4),
                _buildDivider(),
                _buildTab('TRANSFER', 5),
              ],
            ),
          ),

          // Account and Category selectors
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: BaseDropdownPickerField(
                    labelText: 'Account',
                    prefixIcon: Icons.account_balance_wallet,
                    selectedValue: selectedAccount,
                    onTap: _showAccountPicker,
                    hintText: 'Select an account',
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
                  ),
                ),
              ],
            ),
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

          // // Amount display
          // Container(
          //   padding: EdgeInsets.all(20),
          //   child: Container(
          //     padding: EdgeInsets.all(20),
          //     decoration: BoxDecoration(
          //       color: kBackgroundColorCard,
          //       border: Border.all(color: Colors.grey),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Expanded(
          //           child: Text(
          //             currentAmount,
          //             style: kwhiteTextStyle.copyWith(
          //               fontSize: 32,
          //               fontWeight: FontWeight.w300,
          //             ),
          //             textAlign: TextAlign.left,
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: _deleteLastDigit,
          //           child: Container(
          //             padding: EdgeInsets.all(8),
          //             decoration: BoxDecoration(
          //               color: Colors.grey[700],
          //               borderRadius: BorderRadius.circular(4),
          //             ),
          //             child: Icon(
          //               Icons.backspace,
          //               color: Colors.white,
          //               size: 20,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // // Calculator grid
          // Expanded(
          //   child: Padding(
          //     padding: EdgeInsets.all(16),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         _buildCalculatorRow(['+', '7', '8', '9']),
          //         _buildCalculatorRow(['-', '4', '5', '6']),
          //         _buildCalculatorRow(['x', '1', '2', '3']),
          //         _buildCalculatorRow(['÷', '0', '.', '=']),
          //       ],
          //     ),
          //   ),
          // ),

          // // Date and time
          // Container(
          //   padding: EdgeInsets.all(20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Jun 09, 2025',
          //         style: TextStyle(color: Colors.grey, fontSize: 16),
          //       ),
          //       Text(
          //         '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
          //         style: TextStyle(color: Colors.grey, fontSize: 16),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
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
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
