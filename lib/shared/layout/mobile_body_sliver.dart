import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class MobileSliver extends StatelessWidget {
  const MobileSliver({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                title: Text(
                  title,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: whiteColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                backgroundColor: maroonColor,
              )
            ],
        body: body);
  }
}
