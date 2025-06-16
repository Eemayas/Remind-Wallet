import 'package:flutter/material.dart';
import 'package:remind_wallet/theme/color.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Border? border;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.padding,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.inputFillColor,
        padding: padding ?? EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          side: border?.top ?? BorderSide(color: AppColors.inputBorderColor),
        ),
      ),
      child: Text(
        text,
        style: textStyle ??
            Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: textColor ?? AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
      ),
    );
  }
}
