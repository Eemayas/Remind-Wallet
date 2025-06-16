import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerRow extends StatelessWidget {
  final DateTime selectedDateTime;
  final ValueChanged<DateTime> onChanged;
  final TextStyle? textStyle;

  const DateTimePickerRow({
    super.key,
    required this.selectedDateTime,
    required this.onChanged,
    this.textStyle,
  });

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date); // Jun 09, 2024
  }

  String _formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date); // 08:30 PM
  }

  @override
  Widget build(BuildContext context) {
    final style = textStyle ?? Theme.of(context).textTheme.bodyMedium;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date Picker (centered in its space)
          Expanded(
            child: GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDateTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  onChanged(DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    selectedDateTime.hour,
                    selectedDateTime.minute,
                  ));
                }
              },
              child: Center(
                child: Text(
                  _formatDate(selectedDateTime),
                  style: style,
                ),
              ),
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 24,
            color: Colors.grey.withAlpha((0.4 * 255).toInt()),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),

          // Time Picker (centered in its space)
          Expanded(
            child: GestureDetector(
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                );
                if (picked != null) {
                  onChanged(DateTime(
                    selectedDateTime.year,
                    selectedDateTime.month,
                    selectedDateTime.day,
                    picked.hour,
                    picked.minute,
                  ));
                }
              },
              child: Center(
                child: Text(
                  _formatTime(selectedDateTime),
                  style: style,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
