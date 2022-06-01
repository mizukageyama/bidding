import 'package:bidding/components/_components.dart';
import 'package:bidding/components/display_info_section.dart';
import 'package:bidding/main/seller/controllers/manage_item.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
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
          Visibility(
            visible: !isBidder,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    await ManageItem.edit(context, item);
                  },
                  child: const Icon(
                    Icons.edit,
                    color: blackColor,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    await ManageItem.delete(item.itemId);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: blackColor,
                  ),
                ),
                Visibility(
                  visible: (!isBidder &&
                      DateTime.now().isAfter(item.endDate.toDate())),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      CustomButton(
                        onTap: () async {
                          await ManageItem.reOpen(context, item.itemId);
                        },
                        buttonColor: maroonColor,
                        text: 'Reopen Item',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          DisplayInfo(title: 'Condition', content: item.condition),
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
            askingPrice: item.askingPrice,
            item: item,
          ),
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
                        width: 200,
                        child: InputField(
                          controller: controller.bidInput,
                          labelText: 'Enter your bid',
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            return;
                          },
                          onSaved: (value) => controller.bidInput.text = value!,
                          validator: (value) {
                            if (controller.isDoneLoading.value &&
                                controller.bids.isNotEmpty) {
                              int index =
                                  controller.approvedBid(controller.bids);
                              if (index != -1) {
                                return Validator().bid(
                                    value, controller.bids[index].amount, true);
                              } else {
                                return Validator()
                                    .bid(value, item.askingPrice, false);
                              }
                            } else if (controller.isDoneLoading.value &&
                                controller.bids.isEmpty) {
                              return Validator()
                                  .bid(value, item.askingPrice, false);
                            }
                            return 'Something went wrong. Please try again';
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 45,
                        child: CustomButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await controller.submitBid(item.itemId);
                            }
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
            'Date Posted: ${Format.date(item.datePosted)}',
            style: robotoRegular.copyWith(color: greyColor),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Item ${DateTime.now().isBefore(item.endDate.toDate()) ? 'will be' : 'was'} closed: ${Format.date(item.endDate)}',
            style: robotoRegular.copyWith(color: greyColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: DisplayBids(
              bidsController: controller,
              isBidder: isBidder,
              item: item,
            ),
          ),
        ],
      ),
    );
  }
}
