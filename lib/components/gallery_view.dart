import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/controllers/attached_photos_controller.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/material.dart';

class GalleryView extends StatelessWidget {
  GalleryView({Key? key, required this.images}) : super(key: key);
  final AttachedPhotosController apController =
      Get.put(AttachedPhotosController());
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    apController.init(images);

    return Container(
      padding: const EdgeInsets.all(15),
      child: images.length == 1
          ? buildImage(0)
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Obx(
                    () => Stack(
                      children: [
                        CarouselSlider.builder(
                          carouselController: apController.crslController,
                          itemCount: apController.fetchedImages.length,
                          itemBuilder: (context, index, realIndex) {
                            return buildImage(index);
                          },
                          options: CarouselOptions(
                              initialPage: apController.selectedIndex.value,
                              viewportFraction: 1,
                              height: double.infinity,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) =>
                                  apController.selectedIndex.value = index),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: blackColor.withOpacity(0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              child: IconButton(
                                onPressed: apController.prevPhoto,
                                icon: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: blackColor.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: IconButton(
                                onPressed: apController.nextPhoto,
                                icon: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: apController.fetchedImages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Obx(
                                    () => Container(
                                      padding: const EdgeInsets.all(4),
                                      color: index ==
                                              apController.selectedIndex.value
                                          ? maroonColor
                                          : Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          apController.selectedIndex.value =
                                              index;
                                          apController.animateToSlide(index);
                                        },
                                        child: Image.network(
                                          apController.fetchedImages[index],
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                'assets/images/default_image.png',
                                                fit: BoxFit.cover);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildImage(int index) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Image.network(
        apController.fetchedImages[index],
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/default_image.png',
              fit: BoxFit.cover);
        },
      ),
    );
  }
}
