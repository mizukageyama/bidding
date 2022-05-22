import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MobileSliver extends StatelessWidget {
  MobileSliver({
    Key? key,
    required this.title,
    required this.body,
    this.scrollable = true,
  }) : super(key: key);

  final String title;
  final Widget body;
  bool scrollable;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        physics: scrollable
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        floatHeaderSlivers: scrollable,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: scrollable,
                title: Text(
                  title,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: whiteColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: kIsWeb ? 15 : 18,
                  ),
                ),
                backgroundColor: maroonColor,
              )
            ],
        body: body);
  }
}
