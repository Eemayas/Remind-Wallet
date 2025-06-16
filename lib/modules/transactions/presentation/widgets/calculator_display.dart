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
  final EdgeInsets? margin;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;

  const CalculatorDisplay({
    super.key,
    required this.value,
    required this.onDelete,
    this.textStyle,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.contentPadding,
    this.margin,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        initialValue: value,
        validator: validator,
        builder: (field) {
          final hasError = field.hasError;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: backgroundColor ?? AppColors.inputFillColor,
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                  border: Border.all(
                    color: hasError
                        ? AppColors.errorTextColor
                        : AppColors.inputBorderColor,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          children: [
                            Text(
                              value,
                              style: textStyle ?? AppTextStyles.headlineLarge,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              softWrap: false,
                            ),
                          ],
                        ),
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
              ),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Text(
                    field.errorText ?? '',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.errorTextColor),
                  ),
                ),
            ],
          );
        });
  }
}
