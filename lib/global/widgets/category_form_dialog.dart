import 'package:flutter/material.dart';
import 'package:remind_wallet/Componet/input_filed.dart';
import 'package:remind_wallet/global/utils/generate_unique_id.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/global/widgets/transaction_tab_selector.dart';
import 'package:remind_wallet/models/category_model.dart';
import 'package:remind_wallet/models/transaction_icon.dart';
import 'package:remind_wallet/models/transaction_model.dart';
import 'package:remind_wallet/theme/color.dart';
import 'package:remind_wallet/theme/typography.dart';

class CategoryFormDialog extends StatefulWidget {
  final CategoryModel? existingCategory;
  final Function(CategoryModel category, bool isEdit) onCategorySaved;

  const CategoryFormDialog({
    super.key,
    this.existingCategory,
    required this.onCategorySaved,
  });

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  late final TextEditingController _categoryNameController;
  late TransactionType _categoryTransactionType;
  late List<TransactionIcon> _availableIcons;
  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeIcons();
  }

  void _initializeControllers() {
    _categoryNameController = TextEditingController(
      text: widget.existingCategory?.name ?? '',
    );
    _categoryTransactionType =
        widget.existingCategory?.type ?? TransactionType.expense;
  }

  void _initializeIcons() {
    final List<TransactionIcon> incomeIcons = initialIncomeCategoryIcons;

    final List<TransactionIcon> expenseIcons = initialExpenseCategoryIcons;

    final List<TransactionIcon> availableIcons =
        _categoryTransactionType == TransactionType.income ||
                _categoryTransactionType == TransactionType.toReceive
            ? incomeIcons
            : expenseIcons;
    _availableIcons = availableIcons;
    _selectedIcon = widget.existingCategory != null
        ? availableIcons[widget.existingCategory!.iconIndex ?? 0].icon
        : null;
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final category = CategoryModel(
      id: widget.existingCategory?.id ?? generateUniqueId(),
      name: _categoryNameController.text,
      type: _categoryTransactionType,
      iconIndex:
          _availableIcons.indexWhere((icon) => icon.icon == _selectedIcon),
    );

    widget.onCategorySaved(category, widget.existingCategory != null);
    Navigator.of(context).pop();
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AddCategoryForm(
      categoryNameController: _categoryNameController,
      selectedTransactionType: _categoryTransactionType,
      selectedIcon: _selectedIcon,
      availableIcons: _availableIcons,
      onIconSelected: (icon) {
        setState(() {
          _selectedIcon = icon;
        });
      },
      onTransactionTypeSelected: (type) {
        setState(() {
          _categoryTransactionType = type;
          _availableIcons = type == TransactionType.income ||
                  type == TransactionType.toReceive
              ? initialIncomeCategoryIcons
              : initialExpenseCategoryIcons;
        });
      },
      onCancel: _handleCancel,
      onSave: _handleSave,
    );
  }
}

class AddCategoryForm extends StatefulWidget {
  final TextEditingController categoryNameController;
  final TransactionType selectedTransactionType;
  final IconData? selectedIcon;
  final List<TransactionIcon> availableIcons;
  final void Function(IconData) onIconSelected;
  final void Function(TransactionType) onTransactionTypeSelected;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const AddCategoryForm({
    super.key,
    required this.categoryNameController,
    required this.selectedTransactionType,
    this.selectedIcon,
    required this.availableIcons,
    required this.onIconSelected,
    required this.onCancel,
    required this.onSave,
    required this.onTransactionTypeSelected,
  });

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController categoryNameController;

  int selectedTransactionType = 1;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bottomSheetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      titlePadding:
          const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("Type: ", style: AppTextStyles.bodyMedium),
                  SizedBox(
                    width: 220,
                    child: TransactionTabSelector(
                      tabs: [
                        TransactionType.income.name,
                        TransactionType.expense.name,
                      ],
                      selectedIndex: selectedTransactionType,
                      onTabSelected: (index) {
                        setState(() {
                          widget.onTransactionTypeSelected(index == 0
                              ? TransactionType.income
                              : TransactionType.expense);
                          selectedTransactionType = index;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ClearableInputField(
                hintText: "Category Name",
                controller: widget.categoryNameController,
                keyboardType: TextInputType.text,
                labelText: "Category Name",
                prefixIcon: Icons.account_balance_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              IconPickerFormField(
                availableIcons: widget.availableIcons,
                selectedIcon: widget.selectedIcon,
                onIconSelected: widget.onIconSelected,
                labelText: "Pick an Icon",
                fillColor: AppColors.inputFillColor,
                borderRadius: 12.0,
                rowsCount: 2,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomElevatedButton(
                    onPressed: widget.onCancel,
                    icon: Icons.cancel,
                    label: 'Cancel',
                  ),
                  SizedBox(width: 10),
                  CustomElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.onSave();
                      }
                    },
                    icon: Icons.check,
                    label: 'Save',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
