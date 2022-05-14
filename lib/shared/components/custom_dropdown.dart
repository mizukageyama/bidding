import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    required this.hintText,
    required this.dropdownItems,
    required this.onChanged,
    required this.onSaved,
  });
  final String? hintText;
  final List<String>? dropdownItems;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;

  @override
  State createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: blackColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SizedBox(
        width: 240,
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(enabledBorder: InputBorder.none),
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
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ));
  }
}
