import 'package:flutter/material.dart';
import 'package:remind_wallet/Componet/input_filed.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/models/transaction_icon.dart';
import 'package:remind_wallet/theme/color.dart';

class AddAccountForm extends StatefulWidget {
  final TextEditingController accountName;
  final TextEditingController accountInitialAmount;
  final IconData? selectedIcon;
  final List<TransactionIcon> availableIcons;
  final void Function(IconData) onIconSelected;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const AddAccountForm({
    super.key,
    required this.accountName,
    required this.accountInitialAmount,
    required this.selectedIcon,
    required this.availableIcons,
    required this.onIconSelected,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<AddAccountForm> createState() => _AddAccountFormState();
}

class _AddAccountFormState extends State<AddAccountForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
            'Add New Account',
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
              ClearableInputField(
                hintText: "Cash / Bank Account",
                controller: widget.accountName,
                keyboardType: TextInputType.text,
                labelText: "Account Name",
                prefixIcon: Icons.account_balance_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your account name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ClearableInputField(
                hintText: "Initial Amount",
                controller: widget.accountInitialAmount,
                keyboardType: TextInputType.number,
                labelText: "Initial Amount",
                prefixIcon: Icons.money,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your initial amount';
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
