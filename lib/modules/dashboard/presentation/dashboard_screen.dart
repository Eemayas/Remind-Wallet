import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:remind_wallet/models/transaction_model.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final List<Transaction> transactions = [
    // --- June 13, 2025 ---
    Transaction(
      id: '1',
      name: 'Transportation',
      amount: 110,
      type: TransactionType.expense,
      category: 'Transportation',
      date: '2025-06-13',
      account: 'Wallet',
      person: '',
      description: '',
      icon: 'bus',
      createdDate: '2025-06-13',
    ),
    Transaction(
      id: '2',
      name: 'Lunch',
      amount: 250,
      type: TransactionType.expense,
      category: 'Food',
      date: '2025-06-13',
      account: 'Wallet',
      person: '',
      description: '',
      icon: 'utensils',
      createdDate: '2025-06-13',
    ),

    // --- June 12, 2025 ---
    Transaction(
      id: '3',
      name: 'Transportation',
      amount: 110,
      type: TransactionType.expense,
      category: 'Transportation',
      date: '2025-06-12',
      account: 'Wallet',
      person: '',
      description: '',
      icon: 'bus',
      createdDate: '2025-06-12',
    ),

    // --- June 11, 2025 ---
    Transaction(
      id: '4',
      name: 'Dad',
      amount: 500,
      type: TransactionType.income,
      category: 'Family',
      date: '2025-06-11',
      account: 'Wallet',
      person: 'Dad',
      description: '',
      icon: 'shirt',
      createdDate: '2025-06-11',
    ),
    Transaction(
      id: '5',
      name: 'Transportation',
      amount: 110,
      type: TransactionType.expense,
      category: 'Transportation',
      date: '2025-06-11',
      account: 'Wallet',
      person: '',
      description: '',
      icon: 'bus',
      createdDate: '2025-06-11',
    ),
    Transaction(
      id: '6',
      name: 'Groceries',
      amount: 700,
      type: TransactionType.expense,
      category: 'Shopping',
      date: '2025-06-11',
      account: 'Wallet',
      person: '',
      description: '',
      icon: 'cartShopping',
      createdDate: '2025-06-11',
    ),

    // --- June 10, 2025 ---
    Transaction(
      id: '7',
      name: 'Transportation',
      amount: 110,
      type: TransactionType.expense,
      category: 'Transportation',
      date: '2025-06-10',
      account: 'Wallet',
      person: '',
      description: '',
      icon: 'bus',
      createdDate: '2025-06-10',
    ),

    // --- June 09, 2025 ---
    Transaction(
      id: '8',
      name: 'Side Project Payment',
      amount: 1557,
      type: TransactionType.income,
      category: 'Freelancing',
      date: '2025-06-09',
      account: 'Bank',
      person: 'Client A',
      description: 'Flutter app delivery',
      icon: 'laptopCode',
      createdDate: '2025-06-09',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, List<Transaction>> grouped = {};

    final sortedTransactions = [...transactions]
      ..sort((a, b) => b.parsedDateTime.compareTo(a.parsedDateTime));

    for (var tx in sortedTransactions) {
      grouped.putIfAbsent(tx.date, () => []).add(tx);
    }

    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    print(sortedDates);

    return CustomScrollView(
      slivers: [
        // SliverAppBar(
        //   elevation: 0,
        //   pinned: true,
        //   expandedHeight: 200.0,
        //   title: Text(
        //     'Remind Wallet',
        //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
        //           fontWeight: FontWeight.bold,
        //         ),
        //   ),
        //   flexibleSpace: FlexibleSpaceBar(
        //     background: Container(
        //       padding: const EdgeInsets.only(
        //         top: 100,
        //         left: 16,
        //         right: 16,
        //         bottom: 20,
        //       ),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           // _buildTotalBalance(context),
        //           // const SizedBox(height: 20),
        //           // _buildExpenseIncomeRow(context),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        SliverAppBar(
          backgroundColor: const Color(0xFF4A4A4A),
          elevation: 0,
          pinned: true,
          expandedHeight: 200.0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Handle menu tap
            },
          ),
          title: const Text(
            'MyMoney',
            style: TextStyle(
              color: Color(0xFFF4D03F),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Handle search tap
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: const Color(0xFF4A4A4A),
              padding: const EdgeInsets.only(
                top: 100,
                left: 16,
                right: 16,
                bottom: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildMonthNavigation(context),
                  const SizedBox(height: 20),
                  _buildExpenseIncomeRow(context),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              String date = sortedDates[index];
              List<Transaction> dayTxs = grouped[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      DateFormat("MMM dd, EEEE").format(DateTime.parse(date)),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...dayTxs.map(
                    (tx) => GestureDetector(
                      onTap: () => _showTransactionDialog(context, tx),
                      child: _buildTransactionTile(tx),
                    ),
                  ),
                ],
              );
            },
            childCount: sortedDates.length,
          ),
        ),
      ],
    );
    // Scaffold(
    //   backgroundColor: const Color(0xFF2B2B2B),
    //   appBar: AppBar(
    //     title: const Text('MyMoney'),
    //     backgroundColor: const Color(0xFF2B2B2B),
    //     foregroundColor: Colors.yellowAccent,
    //   ),
    //   body: ListView.builder(
    //     itemCount: sortedDates.length,
    //     itemBuilder: (context, index) {
    //       String date = sortedDates[index];
    //       List<Transaction> dayTxs = grouped[date]!;

    //       // print("date: ${date}");
    //       // print("Transaction List: ${dayTxs}");

    //       return Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 16,
    //               vertical: 8,
    //             ),
    //             child: Text(
    //               DateFormat("MMM dd, EEEE").format(DateTime.parse(date)),
    //               style: const TextStyle(
    //                 color: Colors.white70,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //           ...dayTxs.map(
    //             (tx) => GestureDetector(
    //               onTap: () => _showTransactionDialog(context, tx),
    //               child: _buildTransactionTile(tx),
    //             ),

    //             //  _buildTransactionTile(tx)
    //           ),
    //         ],
    //       );
    //     },
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     backgroundColor: Colors.yellowAccent,
    //     onPressed: () {},
    //     child: const Icon(Icons.add),
    //   ),
    // );
  }

  Widget _buildTransactionTile(Transaction tx) {
    IconData iconData = _getIconData(tx.icon);
    Color iconColor = _getTransactionColor(tx.type);
    bool isExpense = tx.type == TransactionType.expense;
    print("iconData: $iconData iconColor: $iconColor ");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(iconData, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.wallet,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tx.account,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isExpense ? '-' : ''}₹${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isExpense ? Colors.redAccent : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'bus':
        return FontAwesomeIcons.bus;
      case 'shirt':
        return FontAwesomeIcons.shirt;
      case 'utensils':
        return FontAwesomeIcons.utensils;
      case 'cartShopping':
        return FontAwesomeIcons.cartShopping;
      case 'laptopCode':
        return FontAwesomeIcons.laptopCode;
      default:
        return FontAwesomeIcons.coins;
    }
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return Colors.greenAccent;
      case TransactionType.expense:
        return Colors.redAccent;
      default:
        return Colors.blueAccent;
    }
  }

  void _showTransactionDialog(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          child: _buildTransactionPopup(transaction),
        );
      },
    );
  }

  Widget _buildTransactionPopup(Transaction transaction) {
    final isExpense = transaction.type == TransactionType.expense;
    final formattedDate = DateFormat(
      "MMM dd, yyyy h:mm a",
    ).format(DateTime.parse(transaction.date));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isExpense ? Colors.deepOrange : Colors.green,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {}, // delete action
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {}, // edit action
                  ),
                ],
              ),
              Text(
                isExpense ? 'EXPENSE' : 'INCOME',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                "${isExpense ? '-' : '+'}रु${transaction.amount}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF3C3B3F),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow("Account", transaction.account, transaction.icon),
              const SizedBox(height: 12),
              _buildInfoRow("Category", transaction.category, transaction.icon),
              const SizedBox(height: 12),
              Text(
                transaction.description.isNotEmpty
                    ? transaction.description
                    : "No notes",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, String? iconPath) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.yellowAccent, fontSize: 16),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.yellowAccent),
            borderRadius: BorderRadius.circular(12),
            color: Colors.black26,
          ),
          child: Row(
            children: [
              if (iconPath != null && iconPath.isNotEmpty)
                Image.asset(iconPath, height: 20, width: 20),
              if (iconPath != null && iconPath.isNotEmpty)
                const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthNavigation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            // Handle previous month
          },
        ),
        Text(
          'June, 2025',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () {
                // Handle next month
              },
            ),
            IconButton(
              icon: const Icon(Icons.tune, color: Colors.white),
              onPressed: () {
                // Handle filter/settings
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseIncomeRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFinanceItem('EXPENSE', 2.03, Colors.red),
        _buildFinanceItem('INCOME', 5.00, Colors.green),
        _buildFinanceItem('TOTAL', 7.03, Colors.green),
      ],
    );
  }

  Widget _buildFinanceItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
