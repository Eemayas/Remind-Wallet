import 'package:flutter/material.dart';

class TransactionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isLoading;

  const TransactionAppBar({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: TextButton(
        onPressed: isLoading ? null : onCancel,
        child: Text(
          '✕  CANCEL',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: isLoading ? Colors.grey : null,
              ),
        ),
      ),
      leadingWidth: 120,
      actions: [
        TextButton(
          onPressed: isLoading ? null : onSave,
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  '✓  SAVE',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
