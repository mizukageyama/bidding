import 'package:bidding/models/sold_item.dart';
import 'package:bidding/screens/seller/sold_item_info.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class SoldItemCard extends StatelessWidget {
  const SoldItemCard({Key? key, required this.product}) : super(key: key);

  final SoldItem product;

  int endTime() {
    return product.endDate.millisecondsSinceEpoch + 1000 * 30;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        () => SoldItemInfoScreen(item: product),
      ),
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: neutralColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              ImageView(
                imageUrl: product.images[0],
                height: Get.height / 4,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(
                  color: blackColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: robotoRegular.copyWith(
                  color: greyColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 30,
          left: 0,
          child: Container(
            color: orangeColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Center(
              child: Text(
                'SOLD',
                style: robotoMedium.copyWith(
                  color: whiteColor,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          width: 120,
        ),
      ]),
    );
  }

  List<Chip> categories() {
    return product.category
        .map(
          (data) => Chip(
            backgroundColor: blackColor,
            label: Text(
              data,
              style: const TextStyle(color: whiteColor, fontSize: 10),
            ),
          ),
        )
        .toList();
  }
}
