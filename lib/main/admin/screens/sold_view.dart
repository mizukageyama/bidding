import 'package:bidding/components/_components.dart';
import 'package:bidding/main/admin/side_menu.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/services/dialogs.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SoldItemView extends StatelessWidget {
  const SoldItemView({Key? key, required this.item}) : super(key: key);
  final SoldItem item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        body: ResponsiveView(
          _Content(
            item: item,
          ),
          AdminSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key, required this.item}) : super(key: key);
  final SoldItem item;

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Text(
                    'Sold Item > ${item.title}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: whiteColor,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
          kIsWeb && Get.width >= 600
              ? Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: LeftColumn(
                              images: item.images,
                            ),
                          ),
                          Expanded(
                            child: _RightColumn(
                              item: item,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    primary: true,
                    children: [
                      LeftColumn(
                        images: item.images,
                      ),
                      _RightColumn(
                        item: item,
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class _RightColumn extends StatelessWidget {
  const _RightColumn({Key? key, required this.item}) : super(key: key);
  final SoldItem item;

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
          FutureBuilder(
            future: item.getBuyerInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return DisplayInfo(
                    title: 'Auction Winner', content: item.buyerName);
              }
              return const SizedBox(
                height: 0,
                width: 0,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Wrap(
              runSpacing: 20,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DisplayInfo(
                  title: 'Asking Price',
                  content: '₱ ${Format.amount(item.askingPrice)}',
                ),
                const SizedBox(
                  width: 15,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_forward_outlined,
                      color: greyColor,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    DisplayInfo(
                      title: 'Sold at',
                      content: '₱ ${Format.amount(item.soldAt)}',
                      isPrice: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            runSpacing: 20,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Item Posted By',
                        style: robotoMedium.copyWith(
                          color: blackColor,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                        future: item.getSellerInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                              item.sellerInfo!.fullName,
                              style: robotoRegular.copyWith(
                                color: greyColor,
                                fontSize: 14,
                              ),
                            );
                          }
                          return Text(
                            '',
                            style: robotoRegular.copyWith(
                              color: greyColor,
                              fontSize: 14,
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      Format.date(item.datePosted),
                      style: robotoRegular.copyWith(color: greyColor),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Closed',
                    style: robotoMedium.copyWith(
                      color: blackColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    Format.date(item.endDate),
                    style: robotoRegular.copyWith(color: greyColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () async {
                showLoading();
                try {
                  // final pdfFile = await PdfService.generate(
                  //   item: item,
                  //   bids: bidsController.bids,
                  // );
                  dismissDialog();
                  //PdfApi.openFile(pdfFile);
                } catch (error) {
                  dismissDialog();
                  showErrorDialog(
                    errorTitle: 'Something went wrong',
                    errorDescription: 'Please try again later',
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: maroonColor,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.picture_as_pdf_outlined,
                      color: whiteColor,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Generate Report',
                      textAlign: TextAlign.center,
                    ),
                  ])),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
