import 'dart:io';
import 'package:bidding/components/_components.dart';
import 'package:bidding/components/for_forms/custom_dropdown2.dart';
import 'package:bidding/components/for_forms/multi_select_category_dp.dart';
import 'package:bidding/components/for_forms/multi_select_dropdown.dart';
import 'package:bidding/main/seller/controllers/add_item_controller.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/main/seller/side_menu.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddItemForm extends StatelessWidget {
  const AddItemForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: SellerSideMenu(),
        body: ResponsiveView(
          _Content(),
          SellerSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);
  final AddItemController addItemController = Get.put(AddItemController());

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
                Visibility(
                  visible: Get.width < 600,
                  child: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: whiteColor,
                    ),
                  ),
                ),
                const Text(
                  'Add Item',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: whiteColor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
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
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                'Item for Auction',
                                style: robotoBold.copyWith(
                                    color: blackColor, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Obx(
                                () => Text(
                                  'Photo ${addItemController.itemImages.length}/10 - You can add up to 10 photos.',
                                  style: robotoMedium.copyWith(
                                      color: greyColor, fontSize: 15),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            Form(
                              key: addItemController.addItemFormKey,
                              child: Wrap(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, right: 30, left: 30),
                                    width: 500,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: greyColor),
                                            color: whiteColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            child: Container(
                                              width: Get.width,
                                              color: whiteColor,
                                              child: Obx(getPhotos),
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () =>
                                              addItemController.category.isEmpty
                                                  ? const SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15),
                                                      child: DeletableCategoryChip(
                                                          controller:
                                                              addItemController),
                                                    ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 500,
                                    padding: const EdgeInsets.only(
                                        top: 15, right: 30, left: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        InputField(
                                          controller:
                                              addItemController.titleController,
                                          labelText: 'Title',
                                          keyboardType: TextInputType.multiline,
                                          onChanged: (value) {
                                            return;
                                          },
                                          onSaved: (value) => addItemController
                                              .titleController.text = value!,
                                          validator: Validator().notEmpty,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        InputField(
                                          controller: addItemController
                                              .descriptionController,
                                          labelText: 'Description',
                                          keyboardType: TextInputType.multiline,
                                          onChanged: (value) {
                                            return;
                                          },
                                          onSaved: (value) => addItemController
                                              .descriptionController
                                              .text = value!,
                                          validator: Validator().notEmpty,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InputField(
                                                controller: addItemController
                                                    .askingPriceController,
                                                labelText: 'Asking Price',
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  return;
                                                },
                                                onSaved: (value) =>
                                                    addItemController
                                                        .titleController
                                                        .text = value!,
                                                validator: Validator().number,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: CustomDropdown2(
                                                hintText: 'Condition',
                                                dropdownItems: condition,
                                                onChanged: (item) =>
                                                    addItemController.condition
                                                        .value = item!,
                                                onSaved: (item) =>
                                                    addItemController.condition
                                                        .value = item!,
                                                validator: (value) {
                                                  if (addItemController
                                                          .condition.value ==
                                                      '') {
                                                    return 'This is a required field';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Obx(
                                          () => MultiCategoryDropdown(
                                            selectedItems: List<String>.from(
                                                addItemController.category),
                                            items: category,
                                            onChanged: (value, selected) {
                                              if (value ==
                                                  'Add Custom Category') {
                                                showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: (context) =>
                                                        addItemController
                                                            .inputDialog());
                                              } else {
                                                if (selected) {
                                                  addItemController.category
                                                      .remove(value);
                                                } else {
                                                  addItemController.category
                                                      .add(value);
                                                }
                                              }
                                            },
                                            validator: (value) {
                                              if (addItemController
                                                  .category.isEmpty) {
                                                return 'Please select a category';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        InputField(
                                          controller:
                                              addItemController.brandController,
                                          labelText: 'Brand (Optional)',
                                          keyboardType: TextInputType.name,
                                          onChanged: (value) {
                                            return;
                                          },
                                          onSaved: (value) => addItemController
                                              .brandController.text = value!,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: greyColor),
                                                  color: whiteColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                  child: getDate(context),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Obx(
                                                () => Text(addItemController
                                                            .date.value ==
                                                        ''
                                                    ? 'Select Date'
                                                    : addItemController
                                                        .date.value),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: greyColor),
                                                  color: whiteColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                  child: getTime(context),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Obx(
                                                () => Text(addItemController
                                                            .time.value ==
                                                        ''
                                                    ? 'Select Time'
                                                    : addItemController
                                                        .time.value),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: 110,
                                          child: CustomButton(
                                            onTap: () async {
                                              if (addItemController
                                                  .addItemFormKey.currentState!
                                                  .validate()) {
                                                await addItemController
                                                    .postItem();
                                              }
                                            },
                                            text: 'Post Item',
                                            buttonColor: maroonColor,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDate(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? selected = await showDatePicker(
          context: context,
          initialDate: addItemController.selectedDate.value,
          firstDate: DateTime(2010),
          lastDate: DateTime(2025),
        );

        if (selected != null) {
          addItemController.date.value = DateFormat.yMMMd().format(selected);
          addItemController.selectedDate.value = selected;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.calendar_month,
              size: 20,
              color: blackColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'End Date of Auction',
                style: robotoBold.copyWith(color: blackColor, fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTime(BuildContext context) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: addItemController.selectedTime.value,
          initialEntryMode: TimePickerEntryMode.dial,
        );
        if (timeOfDay != null) {
          addItemController.time.value = timeOfDay.format(context);
          addItemController.selectedTime.value = timeOfDay;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.schedule,
              size: 20,
              color: blackColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'End Time of Auction',
                style: robotoBold.copyWith(color: blackColor, fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getPhotos() {
    final images = addItemController.itemImages;
    if (images.isEmpty) {
      return InkWell(
        onTap: addItemController.pickForItemSale,
        child: SizedBox(
          height: 330,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
        ),
      );
    }
    return SizedBox(
      height: kIsWeb ? 330 : 250,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          shrinkWrap: true,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 4,
          children: List.generate(images.length + 1, (index) {
            if (index == addItemController.itemImages.length) {
              if (addItemController.itemImages.length == 10) {
                return const SizedBox(
                  height: 0,
                  width: 0,
                );
              }
              return Center(
                child: IconButton(
                  icon: const Icon(Icons.add_to_photos_outlined),
                  color: blackColor,
                  iconSize: 45,
                  onPressed: addItemController.addOnImages,
                ),
              );
            }
            return Stack(
              children: [
                kIsWeb
                    ? Image.network(
                        images[index].path,
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(images[index].path),
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
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
                      addItemController.itemImages.remove(images[index]);
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
      ),
    );
  }
}

class DeletableCategoryChip extends StatelessWidget {
  const DeletableCategoryChip({Key? key, required this.controller})
      : super(key: key);
  final AddItemController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: kIsWeb ? 5 : 1,
      children: [...categories(controller.category)],
    );
  }

  List<Chip> categories(Set<String> items) {
    return items
        .map(
          (data) => Chip(
            deleteIcon: const Icon(
              Icons.highlight_off,
              color: orangeColor,
            ),
            onDeleted: () {
              controller.category.remove(data);
            },
            useDeleteButtonTooltip: true,
            backgroundColor: blackColor,
            label: Text(
              data,
              style: const TextStyle(color: whiteColor, fontSize: 13),
            ),
          ),
        )
        .toList();
  }
}
