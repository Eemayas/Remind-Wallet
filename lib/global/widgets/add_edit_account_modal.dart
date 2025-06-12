import 'package:flutter/material.dart';
import 'package:remind_wallet/Componet/input_filed.dart';
import 'package:remind_wallet/global/widgets/category_option_tile.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/models/transaction_icon.dart';
import 'package:remind_wallet/theme/color.dart';

class AddAccountForm extends StatelessWidget {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClearableInputField(
              hintText: "Cash / Bank Account",
              controller: accountName,
              keyboardType: TextInputType.text,
              labelText: "Account Name",
              prefixIcon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: 20),
            ClearableInputField(
              hintText: "Initial Amount",
              controller: accountInitialAmount,
              keyboardType: TextInputType.number,
              labelText: "Initial Amount",
              prefixIcon: Icons.money,
            ),
            const SizedBox(height: 20),
            const Text(
              "Pick an Icon",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputFillColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    availableIcons.length,
                    (index) {
                      final icon = availableIcons[index].icon;
                      final iconColor = availableIcons[index].color;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
                          onTap: () => onIconSelected(icon),
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
          onPressed: onCancel,
          icon: Icons.cancel,
          label: 'Cancel',
        ),
        CustomElevatedButton(
          onPressed: onSave,
          icon: Icons.check,
          label: 'Save',
        ),
      ],
    );
  }
}
