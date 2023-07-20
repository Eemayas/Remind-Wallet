import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class DropDownButton extends StatelessWidget {
  final TextEditingController Controllerss;
  final String hintText;
  final String labelText;
  final IconData iconsName;
  final List lists;
  final bool isrequired;
  const DropDownButton(
      {super.key,
      required this.Controllerss,
      required this.hintText,
      required this.labelText,
      required this.iconsName,
      this.isrequired = false,
      required this.lists});

  @override
  Widget build(BuildContext context) {
    String? selectedValue;
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        hintStyle: ksubTextStyle,
        labelStyle: kwhiteTextStyle,
        filled: true,
        fillColor: kBackgroundColorCard,
        labelText: labelText,
        // errorText: isrequired && selectedValue == null ? "Select one" : null,
        prefixIcon: Icon(iconsName),
        prefixIconColor: Colors.white,
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: lists
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: kwhiteTextStyle,
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select one.';
        }
        return null;
      },
      onChanged: (value) {
        Controllerss.text = value!;
      },
      onSaved: (value) {
        selectedValue = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        useSafeArea: true,
        decoration: BoxDecoration(
          color: kBackgroundColorCard,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
