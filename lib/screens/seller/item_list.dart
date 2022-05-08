import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(_Content(), sellerSideMenuItem),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);

  final List<Item> item = [
    Item(
      imagePath: 'assets/images/product_sample.png',
      title: 'Raspberry Pi, and Arduino Sensors',
      category: [
        'Electronics',
        'Hardware',
        'Arduino',
        'Electronics',
        'Hardware',
        'Arduino'
      ],
      description:
          'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    ),
    Item(
      imagePath: 'assets/images/product_sample.png',
      title: 'Scientific Calculator',
      category: [
        'Electronics',
        'Hardware',
        'Arduino',
      ],
      description:
          'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    ),
    Item(
      imagePath: 'assets/images/product_sample.png',
      title:
          'EXTERNAL HARD DRIVE SLIM TYPE 100% Health and Battery Good for Life',
      category: [
        'Electronics',
        'Hardware',
        'Arduino',
      ],
      description:
          'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    ),
    Item(
      imagePath: 'assets/images/product_sample.png',
      title: 'Raspberry Pi, and Arduino Sensors',
      category: [
        'Electronics',
        'Hardware',
        'Arduino',
        'Electronics',
        'Hardware',
        'Arduino'
      ],
      description:
          'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    ),
    Item(
      imagePath: 'assets/images/product_sample.png',
      title: 'Scientific Calculator',
      category: [
        'Electronics',
        'Hardware',
        'Arduino',
      ],
      description:
          'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    ),
    Item(
      imagePath: 'assets/images/product_sample.png',
      title: 'Raspberry Pi, and Arduino Sensors',
      category: [
        'Electronics',
        'Hardware',
        'Arduino',
        'Electronics',
        'Hardware',
        'Arduino'
      ],
      description:
          'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    ),
    Item(
      imagePath: 'assets/images/product_sample.png',
      title: 'Scientific Calculator',
      category: [
        'Electronics',
        'Hardware',
        'Arduino',
      ],
      description:
          'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    ),
    Item(
      imagePath: 'assets/images/product_sample.png',
      title:
          'EXTERNAL HARD DRIVE SLIM TYPE 100% Health and Battery Good for Life',
      category: [
        'Electronics',
        'Hardware',
        'Arduino',
      ],
      description:
          'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    ),
    Item(
      imagePath: 'assets/images/product_sample.png',
      title:
          'EXTERNAL HARD DRIVE SLIM TYPE 100% Health and Battery Good for Life',
      category: [
        'Electronics',
        'Hardware',
        'Arduino',
      ],
      description:
          'TAKE ALL Electronic Parts Raspberry Pi, Arduino Sensors, Diodes, LED. These are the Electronic Parts: Raspberry Pi, Arduino Sensors, Diodes, LED, and etc.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
      child: Column(
        children: [
          Container(
            color: maroonColor,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Ongoing Auctions',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: whiteColor,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView(shrinkWrap: true, children: [
            ResponsiveItemGrid(
              item: item,
            ),
          ])),
        ],
      ),
    );
  }
}

class ResponsiveItemGrid extends GetResponsiveView {
  ResponsiveItemGrid({Key? key, required this.item})
      : super(key: key, alwaysUseBuilder: false);

  final List<Item> item;

  @override
  Widget? phone() => ItemLayoutGrid(
        perColumn: 2,
        item: item,
      );

  @override
  Widget? tablet() => ItemLayoutGrid(
        perColumn: 3,
        item: item,
      );

  @override
  Widget? desktop() => ItemLayoutGrid(
        perColumn: 4,
        item: item,
      );
}
