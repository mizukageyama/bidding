import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({Key? key, required this.product}) : super(key: key);

  final Item product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: Colors.transparent, border: Border.all(color: neutralColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: ImageView(
            imageUrl: product.images[0],
            height: Get.height / 4,
          )),
          const SizedBox(
            height: 10,
          ),
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            product.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Flexible(
          //   child: Wrap(
          //     spacing: 5,
          //     runSpacing: 5,
          //     children: [...categories()],
          //   ),
          // )
        ],
      ),
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
