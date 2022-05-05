import 'package:bidding/constants/app_items.dart';
import 'package:bidding/layout/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(const Content(), sellerSideMenuItem),
    );
  }
}

class Content extends StatelessWidget {
  const Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.red,
      child: Text('THIS IS THE CONTENT'),
    );
  }
}
