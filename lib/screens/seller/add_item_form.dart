import 'dart:io';
import 'package:bidding/controllers/_controllers.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddItemForm extends StatelessWidget {
  const AddItemForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveView(_Content(), sellerSideMenuItem),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);

  final AddItemFormController itemForSaleController =
      Get.put(AddItemFormController());

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height,
        width: Get.width,
        color: whiteColor,
        child: ListView(children: [
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
                  'Add Item',
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
          Wrap(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Sale',
                    style: robotoBold.copyWith(color: blackColor, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Photo 0/10 - You can add up to 10 photos.',
                    style:
                        robotoMedium.copyWith(color: greyColor, fontSize: 15),
                    textAlign: TextAlign.right,
                  ),
                  Wrap(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: 550,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(color: greyColor),
                                  color: whiteColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  )),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: Container(
                                    width: Get.width,
                                    color: whiteColor,
                                    child: Obx(getPhotos),
                                  )),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        width: 550,
                        child: Column(children: <Widget>[
                          ItemFormInputField(
                            controller:
                                itemForSaleController.titleNameController,
                            labelText: 'Title',
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) {
                              return;
                            },
                            onSaved: (value) => itemForSaleController
                                .titleNameController.text = value!,
                            validator: Validator().notEmpty,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ItemFormInputField(
                            controller:
                                itemForSaleController.descriptionController,
                            labelText: 'Description',
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) {
                              return;
                            },
                            onSaved: (value) => itemForSaleController
                                .descriptionController.text = value!,
                            validator: Validator().notEmpty,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ItemFormInputField(
                            controller:
                                itemForSaleController.askingPriceController,
                            labelText: 'Asking Price',
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              return;
                            },
                            onSaved: (value) => itemForSaleController
                                .titleNameController.text = value!,
                            validator: Validator().notEmpty,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              child: CustomDropdown(
                            hintText: 'Category',
                            dropdownItems: category,
                            onChanged: (item) =>
                                itemForSaleController.category.value = item!,
                            onSaved: (item) =>
                                itemForSaleController.category.value = item!,
                          )),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              child: CustomDropdown(
                            hintText: 'Condition',
                            dropdownItems: condition,
                            onChanged: (item) =>
                                itemForSaleController.condition.value = item!,
                            onSaved: (item) =>
                                itemForSaleController.condition.value = item!,
                          )),
                          const SizedBox(
                            height: 15,
                          ),
                          ItemFormInputField(
                            controller: itemForSaleController.brandController,
                            labelText: 'Brand (Optional)',
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              return;
                            },
                            onSaved: (value) => itemForSaleController
                                .brandController.text = value!,
                            validator: Validator().notEmpty,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ItemFormInputField(
                            controller: itemForSaleController
                                .enddateofauctionController,
                            labelText: 'End Date of Auction',
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              return;
                            },
                            onSaved: (value) => itemForSaleController
                                .enddateofauctionController.text = value!,
                            validator: Validator().notEmpty,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              height: 40,
                              width: 110,
                              child: CustomButton(
                                onTap: () {},
                                text: 'Post Item',
                                buttonColor: maroonColor,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ])),
                  ]),
                ],
              ),
            ),
          ]),
        ]));
  }

  Widget getPhotos() {
    final images = itemForSaleController.itemImages;
    if (images.isEmpty) {
      return InkWell(
        onTap: itemForSaleController.pickForItemSale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.add_to_photos_outlined,
                size: 67,
                color: blackColor,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Add Photos',
                style: robotoBold.copyWith(color: blackColor, fontSize: 14),
              )
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        shrinkWrap: true,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 3,
        children: List.generate(images.length + 1, (index) {
          if (index == itemForSaleController.itemImages.length) {
            return Center(
              child: IconButton(
                icon: const Icon(Icons.add_to_photos_outlined),
                color: blackColor,
                iconSize: 45,
                onPressed: itemForSaleController.pickForItemSale,
              ),
            );
          }
          return Stack(
            children: [
              kIsWeb
                  ? Image.network(images[index].path)
                  : Image.file(
                      File(images[index].path),
                      width: 140,
                      height: 140,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assests/image/default_image.png',
                            fit: BoxFit.cover);
                      },
                    ),
              Positioned(
                right: 5,
                top: 5,
                child: InkWell(
                  onTap: () {
                    itemForSaleController.itemImages.remove(images[index]);
                  },
                  child: const Icon(
                    Icons.remove_circle,
                    size: 25,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
