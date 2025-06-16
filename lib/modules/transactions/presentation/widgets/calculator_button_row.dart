import 'package:flutter/material.dart';
import 'package:remind_wallet/modules/transactions/presentation/widgets/calculator_button.dart';

class CalculatorButtonRow extends StatelessWidget {
  final List<String> buttons;
  final Function(String) onButtonPressed;
  final EdgeInsets? buttonPadding;
  final double? buttonSpacing;

  const CalculatorButtonRow({
    super.key,
    required this.buttons,
    required this.onButtonPressed,
    this.buttonPadding,
    this.buttonSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((label) {
        return Expanded(
          child: Padding(
            padding: buttonPadding ?? const EdgeInsets.all(4.0),
            child: CalculatorButton(
              text: label,
              onPressed: () => onButtonPressed(label),
            ),
          ),
        );
      }).toList(),
    );
  }
}
