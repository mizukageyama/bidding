import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class MultiSelectDropdown extends StatefulWidget {
  const MultiSelectDropdown({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.selectedItems,
  }) : super(key: key);
  final List<String> items;
  final void Function(String, bool) onChanged;
  final List<String> selectedItems;

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
          border: Border.all(color: greyColor),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Items',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
          items: widget.items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              //disable default onTap to avoid closing menu when selecting an item
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final _isSelected = widget.selectedItems.contains(item);
                  return InkWell(
                    onTap: () {
                      _isSelected
                          ? widget.selectedItems.remove(item)
                          : widget.selectedItems.add(item);

                      widget.onChanged(item, _isSelected);

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
                          _isSelected
                              ? const Icon(Icons.check_box_outlined)
                              : const Icon(Icons.check_box_outline_blank),
                          const SizedBox(width: 16),
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
          value:
              widget.selectedItems.isEmpty ? null : widget.selectedItems.last,
          onChanged: (value) {},
          buttonHeight: 40,
          buttonWidth: 140,
          itemHeight: 40,
          itemPadding: EdgeInsets.zero,
          selectedItemBuilder: (context) {
            return widget.items.map(
              (item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.selectedItems.join(', '),
                      style: const TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                );
              },
            ).toList();
          },
        ),
      ),
    );
  }
}
