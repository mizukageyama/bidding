import 'package:bidding/controllers/attached_photos_controller.dart';
import 'package:bidding/shared/_packages_imports.dart';
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                onPressed: apController.prevPhoto,
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: Get.height * .7,
                width: Get.width * .7,
                color: Colors.transparent,
                child: Obx(
                  () => CarouselSlider.builder(
                    carouselController: apController.crslController,
                    itemCount: apController.fetchedImages.length - 1,
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
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: apController.nextPhoto,
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 110,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: apController.fetchedImages.length - 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Obx(
                            () => Container(
                              padding: const EdgeInsets.all(4),
                              color: index == apController.selectedIndex.value
                                  ? maroonColor
                                  : Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  apController.selectedIndex.value = index;
                                  apController.animateToSlide(index);
                                },
                                child: Image.network(
                                  apController.fetchedImages[index],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
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
    );
  }

  Widget buildImage(int index) {
    return Container(
      color: Colors.grey,
      child: Image.network(
        apController.fetchedImages[index],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/default_image.png',
              fit: BoxFit.cover);
        },
      ),
    );
  }
}
