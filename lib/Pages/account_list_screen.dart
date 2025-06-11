import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_wallet/bloc/expense_bloc.dart';
import 'package:remind_wallet/bloc/expense_state.dart';
import 'package:remind_wallet/global/widgets/account_card.dart';
import 'package:remind_wallet/models/account_model.dart';
import 'package:remind_wallet/theme/color.dart';

class AccountListScreen extends StatelessWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state.status == ExpenseStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ExpenseStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFFD700),
              ),
            );
          }
          if (state.status == ExpenseStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'An error occurred',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (state.status == ExpenseStatus.initial) {
            return Center(
              child: Text(
                'Welcome to Remind Wallet',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                pinned: true,
                expandedHeight: 200.0,
                title: Text(
                  'Remind Wallet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                actions: [
                  // Icon(
                  //   Icons.search,
                  //   color: Color(0xFFFFD700),
                  //   size: 28,
                  // ),
                  // SizedBox(width: 16),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.only(
                        top: 100, left: 16, right: 16, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '[ All Accounts Rs. ${state.amountSummary.currentBalance} ]',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'EXPENSE SO FAR',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Rs. ${state.amountSummary.totalExpenses}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.expenseColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'INCOME SO FAR',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Rs. ${state.amountSummary.totalIncome}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.incomeColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Accounts Section
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Accounts',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 16),

                      // Account Cards
                      AccountCard(
                        account: AccountModel(
                          name: 'Main Account',
                          currentBalance: 10000,
                          iconIndex: 0,
                        ),
                      ),
                      SizedBox(height: 12),
                      // AccountCard(
                      //   name: 'Sanima',
                      //   balance: '₹3,510.00',
                      //   icon: Icons.account_balance_wallet,
                      //   iconColor: Colors.greenAccent,
                      // ),
                      // SizedBox(height: 12),
                      // AccountCard(
                      //   name: 'Saving',
                      //   balance: '₹500.00',
                      //   icon: Icons.savings,
                      //   iconColor: Colors.pinkAccent,
                      // ),
                      // SizedBox(height: 12),
                      // AccountCard(
                      //   name: 'Wallet',
                      //   balance: '₹1,245.00',
                      //   icon: Icons.savings,
                      //   iconColor: Colors.pinkAccent,
                      // ),
                      SizedBox(height: 20),

                      // Add New Account Button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFFFD700),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                            color: Color(0xFFFFD700),
                          ),
                          label: Text(
                            'ADD NEW ACCOUNT',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 80), // Extra space for bottom navigation
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Color(0xFF3C3C3C),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomNavItem(
              icon: Icons.calendar_today,
              label: 'Records',
              isSelected: false,
            ),
            BottomNavItem(
              icon: Icons.pie_chart,
              label: 'Analysis',
              isSelected: false,
            ),
            BottomNavItem(
              icon: Icons.calculate,
              label: 'Budgets',
              isSelected: false,
            ),
            BottomNavItem(
              icon: Icons.account_balance_wallet,
              label: 'Accounts',
              isSelected: true,
            ),
            BottomNavItem(
              icon: Icons.category,
              label: 'Categories',
              isSelected: false,
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Color(0xFF4C4C4C),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(
            Icons.add,
            color: Color(0xFFFFD700),
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? Color(0xFFFFD700) : Colors.grey,
          size: 24,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Color(0xFFFFD700) : Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
