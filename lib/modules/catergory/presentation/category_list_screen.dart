import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_wallet/bloc/expense_bloc.dart';
import 'package:remind_wallet/bloc/expense_event.dart';
import 'package:remind_wallet/bloc/expense_state.dart';
import 'package:remind_wallet/global/widgets/account_summary_header.dart';
import 'package:remind_wallet/global/widgets/category_form_dialog.dart';
import 'package:remind_wallet/models/category_model.dart';
import 'package:remind_wallet/modules/catergory/presentation/widgets/category_section.dart';
import 'package:remind_wallet/services/hive_service.dart';
import 'package:remind_wallet/theme/color.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final hiveService = HiveService();

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
          child: CategorySection(
            categories: state.categories,
            onAddCategory: () => _showAddOrEditCategoryForm(),
            onEditCategory: (category) => _showAddOrEditCategoryForm(
              existingCategory: category,
            ),
            onDeleteCategory: (category) {
              showDeleteAccountDialog(
                context: context,
                category: category,
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddOrEditCategoryForm({CategoryModel? existingCategory}) {
    showDialog(
      context: context,
      builder: (innerContext) => CategoryFormDialog(
        existingCategory: existingCategory,
        onCategorySaved: (category, isEdit) {
          final bloc = context.read<ExpenseBloc>();
          if (isEdit) {
            bloc.add(UpdateCategoryEvent(category));
          } else {
            bloc.add(AddCategoryEvent(category));
          }
        },
      ),
    );
  }

  void showDeleteAccountDialog({
    required BuildContext context,
    required CategoryModel category,
  }) {
    // showDialog(
    //   context: context,
    //   builder: (_) => DeleteAccountDialog(
    //     title: 'Delete Account?',
    //     content:
    //         "Are you sure you want to delete? This action is irreversible.",
    //     onDelete: () {
    //       final bloc = context.read<ExpenseBloc>();
    //       bloc.add(DeleteAccountEvent(account));
    //       // Navigator.pop(context);
    //     },
    //   ),
    // );
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
