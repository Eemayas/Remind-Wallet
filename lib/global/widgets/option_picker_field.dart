import 'package:flutter/material.dart';
import 'package:remind_wallet/theme/color.dart';

class BaseDropdownPickerField extends StatelessWidget {
  final String labelText;
  final String? selectedValue;

  final String hintText;
  final IconData? prefixIcon;
  final VoidCallback onTap;
  final Widget? suffixIcon;
  final bool isEnabled;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final double borderRadius;

  const BaseDropdownPickerField({
    super.key,
    required this.labelText,
    required this.onTap,
    this.selectedValue,
    this.hintText = '',
    this.prefixIcon,
    this.suffixIcon,
    this.isEnabled = true,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.fillColor,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: labelStyle ?? textStyle),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: isEnabled ? onTap : null,
          child: Container(
            padding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: fillColor ?? AppColors.inputFillColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColors.inputBorderColor),
            ),
            child: Row(
              children: [
                if (prefixIcon != null)
                  Icon(prefixIcon, color: Theme.of(context).iconTheme.color),
                if (prefixIcon != null) const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedValue?.isNotEmpty == true
                        ? selectedValue!
                        : hintText,
                    style: selectedValue?.isNotEmpty == true
                        ? textStyle
                        : (hintStyle ??
                            textStyle?.copyWith(color: Colors.grey)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                suffixIcon ??
                    const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
