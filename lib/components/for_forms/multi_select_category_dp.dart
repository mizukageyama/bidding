import 'package:bidding/models/category_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/foundation.dart' as layout;
import 'package:flutter/material.dart';

class MultiCategoryDropdown extends StatefulWidget {
  const MultiCategoryDropdown({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.selectedItems,
    required this.validator,
  }) : super(key: key);

  final List<Category> items;
  final List<String> selectedItems;
  final void Function(String, bool) onChanged;
  final String? Function(String?)? validator;

  @override
  State<MultiCategoryDropdown> createState() => _MultiCategoryDropdownState();
}

class _MultiCategoryDropdownState extends State<MultiCategoryDropdown> {
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
        widget.selectedItems.isEmpty
            ? 'Select Category'
            : widget.selectedItems.join(', '),
        style: robotoRegular.copyWith(
            fontSize: 14,
            color: widget.selectedItems.isEmpty ? null : blackColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: layout.kIsWeb ? 56 : 48,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      items: widget.items
          .map((item) => DropdownMenuItem<String>(
                value: item.value,
                enabled: false,
                child: StatefulBuilder(
                  builder: (context, menuSetState) {
                    final _isSelected = item.isAdd
                        ? true
                        : widget.selectedItems.contains(item.value);
                    return InkWell(
                      onTap: () {
                        _isSelected
                            ? widget.selectedItems.remove(item.value)
                            : widget.selectedItems.add(item.value);

                        widget.onChanged(item.value, _isSelected);

                        //This rebuilds the StatefulWidget to update the button's text
                        setState(() {});
                        //This rebuilds the dropdownMenu Widget to update the check mark
                        menuSetState(() {});
                      },
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            item.isAdd
                                ? const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: maroonColor,
                                    ),
                                  )
                                : _isSelected
                                    ? const Icon(Icons.check_box_outlined)
                                    : const Icon(Icons.check_box_outline_blank),
                            const SizedBox(width: 16),
                            Flexible(
                              child: Text(
                                item.value,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ))
          .toList(),
      dropdownMaxHeight: 250,
      onChanged: (value) {},
      validator: (value) => widget.validator!(''),
      buttonWidth: 140,
      itemHeight: 40,
      itemPadding: EdgeInsets.zero,
      scrollbarAlwaysShow: true,
    );
  }
}
