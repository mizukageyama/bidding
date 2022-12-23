import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    Key? key,
    required this.hintText,
    required this.dropdownItems,
    required this.onChanged,
    required this.onSaved,
    required this.validator,
  }) : super(key: key);

  final String? hintText;
  final List<String>? dropdownItems;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  @override
  State createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
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
      value: selectedItem,
      hint: Text(widget.hintText!),
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      items: widget.dropdownItems!.map((user) {
        return DropdownMenuItem<String>(
          value: user,
          child: Row(
            children: <Widget>[
              Text(
                user,
                style: robotoRegular,
              ),
            ],
          ),
        );
      }).toList(),
      validator: widget.validator,
    );
  }
}
