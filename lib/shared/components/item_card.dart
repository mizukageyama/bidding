import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({Key? key, required this.product}) : super(key: key);

  final Item product;

  int endTime() {
    return product.endDate.millisecondsSinceEpoch + 1000 * 30;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(10),
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
      ),
      Positioned(
        top: 30,
        left: 0,
        child: countdownCard(),
        width: 120,
      ),
    ]);
  }

  Widget countdownCard() {
    return Container(
      color: orangeColor,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: countdownTimer(),
    );
  }

  Widget countdownTimer() {
    return CountdownTimer(
      endTime: endTime(),
      widgetBuilder: (_, time) {
        if (time == null) {
          return const Text('CLOSED');
        }
        int days = time.days ?? 0;
        int daysToHours = days * 24;
        int hours = time.hours ?? 0;
        int overallHours = hours + daysToHours;
        int minutes = time.min ?? 0;
        int seconds = time.sec ?? 0;

        return Text(
          '${overallHours < 10 ? '0$overallHours' : overallHours} '
          ': ${minutes < 10 ? '0$minutes' : minutes} : ${seconds < 10 ? '0$seconds' : seconds}',
          style: const TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        );
      },
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
