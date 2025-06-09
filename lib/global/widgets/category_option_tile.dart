import 'package:flutter/material.dart';

class CategoryOptionTile extends StatelessWidget {
  final String? name;
  final IconData iconData;
  final Color iconBackgroundColor;
  final VoidCallback onTap;
  final bool isLabelVisible;
  final Color? containerColor;

  const CategoryOptionTile(
      {super.key,
      this.name,
      required this.iconData,
      required this.iconBackgroundColor,
      required this.onTap,
      this.isLabelVisible = true,
      this.containerColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: containerColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: iconBackgroundColor,
              child: Icon(
                iconData,
                color: Colors.white,
                size: 28,
              ),
            ),
            if (isLabelVisible) ...[
              const SizedBox(height: 8),
              Text(
                name!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
