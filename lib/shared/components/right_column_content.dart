import 'package:bidding/controllers/bids_controller.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/components/display_bids.dart';
import 'package:bidding/shared/components/display_info_section.dart';
import 'package:bidding/shared/components/display_price.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:bidding/shared/services/validator.dart';
import 'package:flutter/material.dart';

class RightColumnContent extends StatelessWidget {
  RightColumnContent(
      {Key? key,
      required this.isBidder,
      required this.item,
      required this.controller})
      : super(key: key);

  final BidsController controller;
  final TextEditingController bidInput = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool isBidder;
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title.toUpperCase(),
            style: robotoBold.copyWith(
              color: maroonColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          DisplayInfo(title: 'Description', content: item.description),
          const SizedBox(
            height: 15,
          ),
          item.brand == ''
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DisplayInfo(title: 'Brand', content: item.brand),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
          CategoryChip(
            items: item.category,
          ),
          const SizedBox(
            height: 15,
          ),
          DisplayPrice(
              isBidder: isBidder,
              bidsController: controller,
              askingPrice: item.askingPrice),
          Visibility(
            visible: isBidder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: _formKey,
                  child: Wrap(
                    runSpacing: 5,
                    children: [
                      SizedBox(
                        width: 150,
                        child: InputField(
                          controller: bidInput,
                          labelText: 'Enter your bid',
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            return;
                          },
                          onSaved: (value) => bidInput.text = value!,
                          validator: (value) {
                            //TO DO: Revise puhon
                            return Validator().bid(value, item.askingPrice);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 45,
                        child: CustomButton(
                          onTap: () {
                            _formKey.currentState!.validate();
                          },
                          text: 'Submit Bid',
                          buttonColor: maroonColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Item will be closed: ${Format.date(item.endDate)}',
            style: robotoRegular.copyWith(color: greyColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: DisplayBids(
              bidsController: controller,
              isBidder: isBidder,
            ),
          ),
        ],
      ),
    );
  }
}
