import 'package:bidding/components/for_forms/custom_dropdown2.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:flutter/material.dart';

class SearchDropdownField extends StatelessWidget {
  const SearchDropdownField(
      {Key? key,
      required this.topLabel,
      required this.items,
      required this.onChanged})
      : super(key: key);
  final String topLabel;
  final List<String> items;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          topLabel,
          style: robotoMedium.copyWith(
            color: greyColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 48,
          child: CustomDropdown2(
            hintText: 'Select',
            dropdownItems: items,
            onChanged: (item) {
              onChanged!(item);
            },
            onSaved: (item) {
              onChanged!(item);
            },
            validator: (value) {
              return null;
            },
          ),
        ),
      ],
    );
  }
}
