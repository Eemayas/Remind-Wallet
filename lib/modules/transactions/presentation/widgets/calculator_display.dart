import 'package:flutter/material.dart';
import 'package:remind_wallet/theme/color.dart';
import 'package:remind_wallet/theme/typography.dart';

class CalculatorDisplay extends StatelessWidget {
  final String value;
  final VoidCallback onDelete;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Border? border;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const CalculatorDisplay({
    super.key,
    required this.value,
    required this.onDelete,
    this.textStyle,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.inputFillColor,
        border: border ?? Border.all(color: AppColors.inputBorderColor),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              value,
              style: textStyle ?? AppTextStyles.headlineLarge,
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.backspace_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
