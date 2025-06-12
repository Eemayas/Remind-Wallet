import 'package:flutter/material.dart';
import 'package:remind_wallet/global/widgets/custom_button.dart';
import 'package:remind_wallet/theme/color.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final String title;
  final String content;

  const DeleteAccountDialog({
    super.key,
    required this.onDelete,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bottomSheetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      titlePadding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 10,
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
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
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium,
        // "Are you sure you want to delete? This action is irreversible.",
        textAlign: TextAlign.center,
      ),
      actions: [
        CustomElevatedButton(
          onPressed: () => Navigator.pop(context),
          icon: Icons.cancel,
          label: 'Cancel',
        ),
        const SizedBox(width: 10),
        CustomElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onDelete();
          },
          icon: Icons.delete_forever,
          label: 'Delete',
        ),
      ],
    );
  }
}
