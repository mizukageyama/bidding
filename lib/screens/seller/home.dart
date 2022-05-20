import 'package:bidding/screens/seller/_seller_screens.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/seller_side_menu.dart';
import 'package:bidding/shared/layout/test_side_menu.dart';
import 'package:flutter/material.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ResponsiveView(Content(), TestSideMenu()) //SellerSideMenu()),
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
              padding: const EdgeInsets.all(15),
              shrinkWrap: true,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Column(children: [
                      SizedBox(
                        height: 320,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          color: pinkColor,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                'These Deals Are in\na League of Their\nOwn',
                                                style: robotoBold.copyWith(
                                                    color: whiteColor,
                                                    fontSize: 45),
                                                textAlign: TextAlign.justify,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Dont strike out! Score the best pictures\nbefore theyre gone.',
                                                style: robotoMedium.copyWith(
                                                    color: whiteColor,
                                                    fontSize: 15),
                                                textAlign: TextAlign.justify,
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
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                //  Get.to(() => ItemListScreen());
                                              },
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      'Add Auction Item',
                                                      style:
                                                          robotoMedium.copyWith(
                                                              color: whiteColor,
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
                        height: 12,
                      ),
                      Wrap(
                          runSpacing: 10,
                          runAlignment: WrapAlignment.spaceAround,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              width: 650,
                              height: 325,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                                // image: const DecorationImage(
                                //     image: AssetImage(
                                //         'assets/images/auction_image.jpg'),
                                //     fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              width: 570,
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Container(
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    color: fadeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Total Auctioned',
                                                            style: robotoMedium
                                                                .copyWith(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        16),
                                                            textAlign:
                                                                TextAlign.left),
                                                        const SizedBox(
                                                            height: 15),
                                                        Text('30',
                                                            style: robotoMedium
                                                                .copyWith(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        30),
                                                            textAlign:
                                                                TextAlign.left)
                                                      ]),
                                                ))),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                  color: orangeColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Open Auctions',
                                                            style: robotoMedium
                                                                .copyWith(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        16),
                                                            textAlign:
                                                                TextAlign.left),
                                                        const SizedBox(
                                                            height: 15),
                                                        Text('--',
                                                            style: robotoMedium
                                                                .copyWith(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        30),
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
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
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
                                                                      fontSize:
                                                                          16),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left),
                                                          const SizedBox(
                                                              height: 15),
                                                          Text('12',
                                                              style: robotoMedium
                                                                  .copyWith(
                                                                      color:
                                                                          whiteColor,
                                                                      fontSize:
                                                                          30),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left)
                                                        ])))),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                  color: redColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Closed Auctions',
                                                            style: robotoMedium
                                                                .copyWith(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        16),
                                                            textAlign:
                                                                TextAlign.left),
                                                        const SizedBox(
                                                            height: 15),
                                                        Text('--',
                                                            style: robotoMedium
                                                                .copyWith(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        30),
                                                            textAlign:
                                                                TextAlign.left)
                                                      ]))),
                                        )
                                      ],
                                    )
                                  ]),
                            )
                          ])
                    ]),
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
