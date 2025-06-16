import 'package:flutter/material.dart';
import 'package:remind_wallet/modules/transactions/logic/calculator_logic.dart';
import 'package:remind_wallet/modules/transactions/presentation/widgets/calculator_button_row.dart';
import 'package:remind_wallet/modules/transactions/presentation/widgets/calculator_display.dart';

class CalculatorWidget extends StatefulWidget {
  final String? initialValue;
  final Function(String)? onValueChanged;
  final List<List<String>>? customButtons;
  final String? Function(String?)? validator;

  const CalculatorWidget({
    super.key,
    this.initialValue,
    this.onValueChanged,
    this.customButtons,
    this.validator,
  });

  @override
  CalculatorWidgetState createState() => CalculatorWidgetState();
}

class CalculatorWidgetState extends State<CalculatorWidget> {
  late String currentAmount;

  // Default button layout
  static const List<List<String>> defaultButtons = [
    ['7', '8', '9', '÷'],
    ['4', '5', '6', 'x'],
    ['1', '2', '3', '-'],
    ['0', '.', '=', '+'],
  ];

  @override
  void initState() {
    super.initState();
    currentAmount = widget.initialValue ?? '0';
  }

  void _onButtonPressed(String button) {
    setState(() {
      if (_isNumber(button)) {
        currentAmount =
            CalculatorLogic.processNumberInput(currentAmount, button);
      } else if (button == '=') {
        currentAmount = CalculatorLogic.calculateResult(currentAmount);
      } else {
        currentAmount =
            CalculatorLogic.processOperatorInput(currentAmount, button);
      }
    });

    // Notify parent widget of value change
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(currentAmount);
    }
  }

  void _onDelete() {
    setState(() {
      currentAmount = CalculatorLogic.deleteLastDigit(currentAmount);
    });

    // Notify parent widget of value change
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(currentAmount);
    }
  }

  bool _isNumber(String value) {
    return RegExp(r'^[0-9]$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    final buttons = widget.customButtons ?? defaultButtons;

    return Column(
      children: [
        CalculatorDisplay(
          value: currentAmount,
          onDelete: _onDelete,
          validator: widget.validator,
        ),
        SizedBox(height: 20),
        ...buttons.map((row) => Column(
              children: [
                CalculatorButtonRow(
                  buttons: row,
                  onButtonPressed: _onButtonPressed,
                ),
                SizedBox(height: 8),
              ],
            )),
      ],
    );
  }
}
