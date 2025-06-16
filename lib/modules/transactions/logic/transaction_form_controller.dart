import 'package:flutter/material.dart';
import 'package:remind_wallet/global/utils/generate_unique_id.dart';
import 'package:remind_wallet/models/transaction_model.dart';

class TransactionFormController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController toFromController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController accountInitialAmount = TextEditingController();
  final TextEditingController accountName = TextEditingController();

  String currentAmount = '0';
  String selectedAccountId = 'Account';
  String selectedCategory = 'Category';
  TransactionType type = TransactionType.expense;
  int selectedTab = 1;
  DateTime selectedDateTime = DateTime.now();

  void updateAmount(String value) {
    currentAmount = value;
  }

  void updateSelectedTab(int index) {
    selectedTab = index;
  }

  void updateAccount(String accountId) {
    selectedAccountId = accountId;
  }

  void updateCategory(String category) {
    selectedCategory = category;
  }

  void updateDateTime(DateTime dateTime) {
    selectedDateTime = dateTime;
  }

  void resetForm() {
    currentAmount = '0';
    selectedAccountId = 'Account';
    selectedCategory = 'Category';
    toFromController.clear();
    notesController.clear();
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Transaction createTransaction() {
    return Transaction(
      id: generateUniqueId(),
      name: toFromController.text,
      amount: int.tryParse(currentAmount) ?? 0,
      type: type,
      category: selectedCategory,
      date: selectedDateTime.toIso8601String(),
      account: selectedAccountId,
      person: "",
      description: notesController.text,
      createdDate: DateTime.now().toIso8601String(),
    );
  }

  void dispose() {
    toFromController.dispose();
    notesController.dispose();
    accountInitialAmount.dispose();
    accountName.dispose();
  }
}
