import 'package:flutter/material.dart';
import 'package:remind_wallet/global/widgets/category_option_tile.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/models/category_model.dart';
import 'package:remind_wallet/models/transaction_icon.dart';
import 'package:remind_wallet/models/transaction_model.dart';
import 'package:remind_wallet/theme/color.dart';

class CategoryPickerBottomSheet extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedCategory;
  final int selectedTab;
  final Function(String) onCategorySelected;
  final VoidCallback onAddNewCategory;

  const CategoryPickerBottomSheet({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.selectedTab,
    required this.onCategorySelected,
    required this.onAddNewCategory,
  });

  List<CategoryModel> get filteredCategories {
    return categories.where((category) {
      if (selectedTab == 0 || selectedTab == 3) {
        return category.type == TransactionType.income;
      } else {
        return category.type == TransactionType.expense;
      }
    }).toList();
  }

  List<TransactionIcon> get availableIcons {
    return selectedTab == 0 || selectedTab == 3
        ? initialIncomeCategoryIcons
        : initialExpenseCategoryIcons;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bottomSheetColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
              children: filteredCategories.map((category) {
                return CategoryOptionTile(
                  name: category.name,
                  iconData: availableIcons[category.iconIndex ?? 0].icon,
                  iconBackgroundColor:
                      availableIcons[category.iconIndex ?? 0].color,
                  onTap: () {
                    onCategorySelected(category.name);
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
              onPressed: onAddNewCategory,
              icon: Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
