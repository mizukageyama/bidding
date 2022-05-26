import 'package:bidding/models/category_model.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({
    Key? key,
    required this.hintText,
    required this.dropdownItems,
    required this.onChanged,
    required this.onSaved,
    required this.validator,
  }) : super(key: key);
  final String? hintText;

  final List<Category>? dropdownItems;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  @override
  State createState() => CategoryDropdownState();
}

class CategoryDropdownState extends State<CategoryDropdown> {
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
      items: widget.dropdownItems!.map((item) {
        return DropdownMenuItem<String>(
          value: item.value,
          child: Row(
            children: <Widget>[
              item.isAdd
                  ? const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.add_circle_outline_rounded,
                        color: maroonColor,
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              Text(
                item.value,
                style: robotoRegular.copyWith(
                    color: item.isAdd ? maroonColor : blackColor),
              ),
            ],
          ),
        );
      }).toList(),
      validator: widget.validator,
    );
  }
}
