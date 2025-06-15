// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:remind_wallet/constant.dart';
import 'package:remind_wallet/global/widgets/category_option_tile.dart';
import 'package:remind_wallet/models/transaction_icon.dart';
import 'package:remind_wallet/theme/color.dart';
import 'package:remind_wallet/theme/typography.dart';

class InputField extends StatefulWidget {
  const InputField(
      {super.key,
      required this.controllerss,
      required this.keyboardType,
      required this.labelText,
      required this.prefixIcon,
      required this.hintText,
      this.isEnable = true,
      this.textCapitalization = TextCapitalization.sentences,
      this.isUserDetail = false,
      this.isrequired = false,
      this.isPassword = false});
  final String hintText;
  final TextCapitalization textCapitalization;
  final TextEditingController controllerss;
  final TextInputType keyboardType;
  final String labelText;
  final IconData prefixIcon;
  final bool isrequired;
  final bool isPassword;
  final bool isEnable;
  final bool isUserDetail;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget.textCapitalization,
      enabled: widget.isEnable,
      controller: widget.controllerss,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
        // }
      },
      obscureText: widget.isPassword && !passwordVisible,
      cursorColor: Colors.white,
      style: kwhiteTextStyle,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              )
            : widget.isUserDetail
                ? Container(width: 0)
                : widget.controllerss.text.isEmpty
                    ? Container(width: 0)
                    : IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.close),
                        onPressed: () => widget.controllerss.clear(),
                      ),
        labelStyle: kwhiteTextStyle,
        filled: true,
        hintStyle: ksubTextStyle,
        fillColor: kBackgroundColorCard,
        labelText: widget.labelText,
        prefixIcon: Icon(widget.prefixIcon),
        prefixIconColor: Colors.white,
        hintText: widget.hintText,
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class BaseInputField extends StatefulWidget {
  const BaseInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText = '',
    this.isEnabled = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.validator,
    this.obscureText = false,
    this.onSuffixIconPressed,
    this.fillColor,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.borderRadius = 8.0,
    this.maxLines,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final bool isEnabled;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;
  final Color? fillColor;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final int? maxLines;

  @override
  State<BaseInputField> createState() => _BaseInputFieldState();
}

class _BaseInputFieldState extends State<BaseInputField> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        validator: widget.validator,
        style: widget.style ?? Theme.of(context).textTheme.labelLarge,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          labelStyle:
              widget.labelStyle ?? Theme.of(context).textTheme.labelLarge,
          filled: true,
          hintStyle: widget.hintStyle ?? Theme.of(context).textTheme.labelLarge,
          fillColor: widget.fillColor,
          labelText: widget.labelText,
          prefixIcon:
              widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          prefixIconColor: Theme.of(context).iconTheme.color,
          hintText: widget.hintText,
          contentPadding: widget.contentPadding ??
              const EdgeInsets.fromLTRB(32, 16, 32, 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        textCapitalization: widget.textCapitalization,
        enabled: widget.isEnabled,
        controller: widget.controller,
        obscureText: widget.obscureText,
        cursorColor: AppColors.cursorColor,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
      ),
    );
  }
}

// Password Input Field
class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    this.isEnabled = true,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isEnabled;

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BaseInputField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      isEnabled: widget.isEnabled,
      obscureText: !passwordVisible,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: Icons.lock,
      textCapitalization: TextCapitalization.none,
      suffixIcon: IconButton(
        icon: Icon(
          passwordVisible ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            passwordVisible = !passwordVisible;
          });
        },
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        return null;
      },
    );
  }
}

// Clearable Input Field
class ClearableInputField extends StatelessWidget {
  const ClearableInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
    this.maxLines,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return BaseInputField(
          controller: controller,
          labelText: labelText,
          hintText: hintText,
          keyboardType: keyboardType,
          prefixIcon: prefixIcon,
          validator: validator,
          suffixIcon: value.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => controller.clear(),
                )
              : null,
          maxLines: maxLines,
        );
      },
    );
  }
}

class BaseDropdownField extends StatefulWidget {
  const BaseDropdownField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.items,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText = '',
    this.isEnabled = true,
    this.validator,
    this.onSuffixIconPressed,
    this.fillColor,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding,
    this.borderRadius = 8.0,
  });

  final TextEditingController controller;
  final String labelText;
  final List<String> items;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final bool isEnabled;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixIconPressed;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final double borderRadius;

  @override
  State<BaseDropdownField> createState() => _BaseDropdownFieldState();
}

class _BaseDropdownFieldState extends State<BaseDropdownField> {
  late String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.controller.text.isNotEmpty
        ? widget.controller.text
        : null; // Initialize with controller text if available
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: widget.validator,
      style: widget.style ?? Theme.of(context).textTheme.labelLarge,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        labelStyle: widget.labelStyle ?? Theme.of(context).textTheme.labelLarge,
        filled: true,
        hintStyle: widget.hintStyle ?? Theme.of(context).textTheme.labelLarge,
        fillColor: widget.fillColor,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        prefixIconColor: Theme.of(context).iconTheme.color,
        hintText: widget.hintText,
        contentPadding:
            widget.contentPadding ?? const EdgeInsets.fromLTRB(32, 16, 32, 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
      value: selectedValue,
      onChanged: widget.isEnabled
          ? (String? newValue) {
              setState(() {
                selectedValue = newValue;
                widget.controller.text = newValue ?? ''; // Update controller
              });
            }
          : null,
      items: widget.items
          .map<DropdownMenuItem<String>>(
            (String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
    );
  }
}

// Custom Dropdown Input Field with Icon (e.g., Country Picker, etc.)
class DropdownInputField extends StatelessWidget {
  const DropdownInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.items,
    this.hintText = '',
    this.isEnabled = true,
    this.prefixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String labelText;
  final List<String> items;
  final String hintText;
  final bool isEnabled;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return BaseDropdownField(
        controller: controller,
        labelText: labelText,
        items: items,
        hintText: hintText,
        isEnabled: isEnabled,
        prefixIcon: prefixIcon,
        validator: validator);
  }
}

class IconPickerFormField extends FormField<IconData> {
  IconPickerFormField({
    Key? key,
    required List<TransactionIcon> availableIcons,
    required IconData? selectedIcon,
    required ValueChanged<IconData> onIconSelected,
    String labelText = 'Pick an Icon',
    TextStyle? labelStyle,
    String? Function(String?)? validator,
    Color? fillColor,
    TextStyle? style,
    TextStyle? hintStyle,
    double borderRadius = 12.0,
    int rowsCount = 1,
    EdgeInsetsGeometry? contentPadding,
  }) : super(
          key: key,
          validator: (_) {
            if (selectedIcon == null) return 'Please select an icon';
            return null;
          },
          builder: (FormFieldState<IconData> field) {
            final bool hasError = field.hasError;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(labelText, style: labelStyle ?? AppTextStyles.bodyMedium),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: hasError
                          ? AppColors.inputErrorBorderColor
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  padding: contentPadding ?? const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        (availableIcons.length / rowsCount).ceil(),
                        (colIndex) {
                          // final icon = availableIcons[colIndex].icon;
                          // final iconColor = availableIcons[colIndex].color;

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Column(
                              children: List.generate(rowsCount, (rowIndex) {
                                int index = colIndex * rowsCount + rowIndex;
                                if (index >= availableIcons.length) {
                                  return SizedBox();
                                }
                                IconData icon = availableIcons[index].icon;
                                Color iconColor = availableIcons[index].color;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: CategoryOptionTile(
                                    iconData: icon,
                                    iconBackgroundColor: iconColor,
                                    isLabelVisible: false,
                                    containerColor: selectedIcon == icon
                                        ? Colors.white.withOpacity(0.2)
                                        : Colors.transparent,
                                    onTap: () {
                                      onIconSelected(icon);
                                      field.didChange(icon);
                                    },
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      field.errorText ?? '',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.errorTextColor),
                    ),
                  ),
              ],
            );
          },
        );
}
