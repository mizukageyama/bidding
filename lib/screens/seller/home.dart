import 'package:bidding/screens/seller/_seller_screens.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(Content(), sellerSideMenuItem),
    );
  }
}

class Content extends StatelessWidget {
  Content({Key? key}) : super(key: key);

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
                  'Dashboard',
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
              child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(children: [
                          SizedBox(
                            height: 320,
                            width: Get.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              color: pinkColor,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'These Deals Are in\n a League of Their\n Own',
                                                    style: robotoBold.copyWith(
                                                        color: whiteColor,
                                                        fontSize: 45),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Dont strike out! Score the best pictures\n before theyre gone.',
                                                    style:
                                                        robotoMedium.copyWith(
                                                            color: whiteColor,
                                                            fontSize: 15),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ],
                                              )
                                            ]),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        SizedBox(
                                            height: 40,
                                            width: 150,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: whiteColor)),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    //  Get.to(() => ItemListScreen());
                                                  },
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          'Add Auction Item',
                                                          style: robotoMedium
                                                              .copyWith(
                                                                  color:
                                                                      whiteColor,
                                                                  fontSize: 14),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Icon(
                                                          Icons.arrow_forward,
                                                          color: whiteColor,
                                                        ),
                                                      ]),
                                                ))),
                                      ])),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Wrap(children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 10, right: 30),
                              width: 650,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: Get.width,
                                      height: 315,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/auction_image.jpg'),
                                              fit: BoxFit.cover)),
                                    )
                                  ]),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              width: 570,
                              child: Column(children: [
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                            height: 150,
                                            decoration: BoxDecoration(
                                                color: fadeColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Total Auctioned',
                                                        style: robotoMedium
                                                            .copyWith(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 16),
                                                        textAlign:
                                                            TextAlign.left),
                                                    const SizedBox(height: 15),
                                                    Text('30',
                                                        style: robotoMedium
                                                            .copyWith(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 30),
                                                        textAlign:
                                                            TextAlign.left)
                                                  ]),
                                            ))),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                              color: orangeColor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Open Auctions',
                                                        style: robotoMedium
                                                            .copyWith(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 16),
                                                        textAlign:
                                                            TextAlign.left),
                                                    const SizedBox(height: 15),
                                                    Text('--',
                                                        style: robotoMedium
                                                            .copyWith(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 30),
                                                        textAlign:
                                                            TextAlign.left)
                                                  ]))),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Container(
                                            height: 150,
                                            decoration: BoxDecoration(
                                                color: blueColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Sold Items',
                                                          style: robotoMedium
                                                              .copyWith(
                                                                  color:
                                                                      whiteColor,
                                                                  fontSize: 16),
                                                          textAlign:
                                                              TextAlign.left),
                                                      const SizedBox(
                                                          height: 15),
                                                      Text('12',
                                                          style: robotoMedium
                                                              .copyWith(
                                                                  color:
                                                                      whiteColor,
                                                                  fontSize: 30),
                                                          textAlign:
                                                              TextAlign.left)
                                                    ])))),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                              color: redColor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Closed Auctions',
                                                        style: robotoMedium
                                                            .copyWith(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 16),
                                                        textAlign:
                                                            TextAlign.left),
                                                    const SizedBox(height: 15),
                                                    Text('--',
                                                        style: robotoMedium
                                                            .copyWith(
                                                                color:
                                                                    whiteColor,
                                                                fontSize: 30),
                                                        textAlign:
                                                            TextAlign.left)
                                                  ]))),
                                    )
                                  ],
                                )
                              ]),
                            )
                          ])
                        ])),
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
