import 'package:flutter/material.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/models/category_model.dart';
import 'package:remind_wallet/models/transaction_model.dart';
import 'package:remind_wallet/modules/account/presentation/widgets/empty_accounts_widget.dart';
import 'package:remind_wallet/modules/catergory/presentation/widgets/category_card.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryModel> categories;
  final VoidCallback onAddCategory;
  final Function(CategoryModel) onEditCategory;
  final Function(CategoryModel) onDeleteCategory;

  const CategorySection({
    super.key,
    required this.categories,
    required this.onAddCategory,
    required this.onEditCategory,
    required this.onDeleteCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Income Categories'),
          const SizedBox(height: 16),
          _buildCategoryList(TransactionType.income),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'Expenses Categories'),
          const SizedBox(height: 16),
          _buildCategoryList(TransactionType.expense),
          const SizedBox(height: 12),
          _buildAddCategoryButton(),
          const SizedBox(height: 80), // Extra space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 4),
        Divider(
          color: Theme.of(context).textTheme.bodyMedium!.color,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildCategoryList(TransactionType type) {
    if (categories.isEmpty) {
      return const EmptyAccountsWidget();
    }

    List<CategoryModel> filteredCategories =
        categories.where((element) => element.type == type).toList();

    return Column(
      children: filteredCategories.map((category) {
        print("CategoryCard created - I: $category ${category.type} ");
        return Column(
          children: [
            CategoryCard(
              category: category,
              onEdit: () => onEditCategory(category),
              onDelete: () => onDeleteCategory(category),
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAddCategoryButton() {
    return Center(
      child: CustomElevatedButton(
        onPressed: onAddCategory,
        label: 'ADD NEW CATEGORY',
        icon: Icons.add,
      ),
    );
  }
}
