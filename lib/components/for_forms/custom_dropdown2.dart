import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class CustomDropdown2 extends StatefulWidget {
  const CustomDropdown2({
    Key? key,
    required this.hintText,
    required this.dropdownItems,
    required this.onChanged,
    required this.onSaved,
    required this.validator,
  }) : super(key: key);

  final String hintText;
  final List<String> dropdownItems;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  @override
  State<CustomDropdown2> createState() => _CustomDropdown2State();
}

class _CustomDropdown2State extends State<CustomDropdown2> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        filled: true,
        fillColor: whiteColor,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: maroonColor),
            borderRadius: BorderRadius.circular(10)),
      ),
      isExpanded: true,
      hint: Text(
        widget.hintText,
        style: robotoRegular.copyWith(fontSize: 14),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      items: widget.dropdownItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }
}
