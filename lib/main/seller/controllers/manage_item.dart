import 'dart:core';
import 'package:bidding/components/_components.dart';
import 'package:bidding/components/for_forms/custom_dropdown2.dart';
import 'package:bidding/main/seller/controllers/add_item_controller.dart';
import 'package:bidding/main/seller/controllers/seller_side_menu_controller.dart';
import 'package:bidding/main/seller/screens/sold_item_list.dart';
import 'package:bidding/models/bid_model.dart';
import 'package:bidding/models/item_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageItem extends GetxController {
  static final log = getLogger('Manage Item');

  //Reopening Closed Item - Date and Time Input
  static final Rx<DateTime> selectedDate = DateTime.now().obs;
  static final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  static final RxString time = ''.obs;
  static final RxString date = ''.obs;

  //Edit Controllers
  static TextEditingController titleController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController brandController = TextEditingController();
  static TextEditingController askingPriceController = TextEditingController();
  static RxString cond = ''.obs;

  final AddItemController addItemController = Get.put(AddItemController());

  //EDIT SELECTED AUCTIONED ITEM
  static Future<void> edit(BuildContext context, Item item) async {
    await showDialog(
        context: context, builder: (context) => editItemDialog(item, context));
  }

  static Future<void> updateItem(Item item) async {
    return firestore.collection('items').doc(item.itemId).update({
      'title': titleController.text,
      'description': descriptionController.text,
      'brand': brandController.text,
      'asking_price': double.parse(askingPriceController.text),
      'condition': cond.value,
    }).then((value) {
      dismissDialog();
      showSimpleDialog(
          title: 'Item Updated Successfully',
          description:
              'The information of your auctioned item has been updated.');
      titleController.clear();
      descriptionController.clear();
      brandController.clear();
      askingPriceController.clear();
      cond.value = '';
    }).catchError((_) {
      dismissDialog();
      showErrorDialog(
          errorTitle: 'An error occured',
          errorDescription:
              'Something went wrong while updating the information of your item. Please try again later.');
    });
  }

  //DELETE SELECTED AUCTIONED ITEM
  static Future<void> deleteUsingBatch(String itemId) async {
    showLoading();
    final batch = firestore.batch();

    //delete item
    final itemRef = firestore.collection('items').doc(itemId);
    batch.delete(itemRef);

    //delete its bids child
    final bidsRef = firestore.collection('bids');
    final List<DocumentSnapshot> bids = await bidsRef
        .where('item_id', isEqualTo: itemId)
        .get()
        .then((snapshot) => snapshot.docs);

    for (DocumentSnapshot ds in bids) {
      ds.reference.delete();
    }

    // Commit the batch
    batch.commit().then((_) async {
      await deleteItemImages(itemId).then((value) {
        log.i('Success deleting its photos on storage');
      }).catchError((onError) {
        log.i('Should notify admin about the item photos that wasn\'t deleted');
      });
      dismissDialog();
      showSimpleDialog(
          title: 'Item Deleted Successfully',
          description: 'The selected auctioned item has been deleted.');
    }).catchError((onError) {
      log.i('Unable to delete item and its bid');
      dismissDialog();
      showErrorDialog(
          errorTitle: 'An error occured',
          errorDescription:
              'Something went wrong while deleting your item. Please try again later.');
    });
  }

  //Delete Storage Images
  static Future<void> deleteItemImages(String itemId) async {
    await storage.ref("item_images/$itemId").listAll().then((value) {
      for (var element in value.items) {
        storage.ref(element.fullPath).delete();
      }
    });
  }

  //RE-OPEN CLOSED ITEM
  static Future<void> reOpen(BuildContext context, String itemId) async {
    await showDialog(
        context: context,
        builder: (context) => reOpenItemDialog(itemId, context));
  }

  static Future<void> updateEndDate(String itemId) async {
    Timestamp endTimeStamp = Timestamp.fromDate(endDateValue());
    return firestore.collection('items').doc(itemId).update({
      'end_date': endTimeStamp,
      'winning_bid': '',
    });
  }

  static Future<void> markItemAsSold(Item item) async {
    showLoading();
    final Bid winningBid = await firestore
        .collection('bids')
        .doc(item.winningBid)
        .get()
        .then((snapshot) => Bid.fromJson(snapshot.data()!));
    markItemAsSoldBatch(item, winningBid);
  }

  //Marking Item as Sold in Batch
  static Future<void> markItemAsSoldBatch(Item item, Bid winningBid) async {
    final batch = firestore.batch();

    final soldItemRef = firestore.collection('sold_items').doc(item.itemId);
    batch.set(soldItemRef, {
      'item_id': item.itemId,
      'seller_id': item.sellerId,
      'title': item.title,
      'description': item.description,
      'asking_price': item.askingPrice,
      'brand': item.brand,
      'date_posted': item.datePosted,
      'end_date': item.endDate,
      'date_sold': Timestamp.now(),
      'category': List<String>.from(item.category),
      'condition': item.condition,
      'sold_at': winningBid.amount,
      'buyer_id': winningBid.bidderId,
      'images': List<String>.from(item.images),
    });

    final itemRef = firestore.collection('items').doc(item.itemId);
    batch.delete(itemRef);

    // Commit the batch
    batch.commit().then((_) async {
      dismissDialog();
      SellerSideMenuController menu = Get.find();
      menu.changeActiveItem('Sold Items');
      Get.to(() => const SoldItemList());
    }).catchError((onError) {
      dismissDialog();
      showErrorDialog(
          errorTitle: 'An error occured',
          errorDescription:
              'Something went wrong updating your item. Please try again later.');
    });
  }

  static DateTime endDateValue() {
    final TimeOfDay t = selectedTime.value;
    final DateTime d = selectedDate.value;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  //DIALOGS
  static Widget editItemDialog(Item item, BuildContext context) {
    final _editFormkey = GlobalKey<FormState>();
    titleController.text = item.title;
    descriptionController.text = item.description;
    brandController.text = item.brand;
    askingPriceController.text = '${item.askingPrice}';
    cond.value = item.condition;

    return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 20, horizontal: kIsWeb ? 30 : 5),
        children: [
          Column(
            children: [
              Text(
                'Update Item Info',
                textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: 15),
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: _editFormkey,
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InputField(
                        controller: titleController,
                        labelText: 'Title',
                        onChanged: (value) {
                          return;
                        },
                        onSaved: (value) => titleController.text = value!,
                        validator: Validator().notEmpty,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        controller: descriptionController,
                        labelText: 'Description',
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          return;
                        },
                        onSaved: (value) => descriptionController.text = value!,
                        validator: Validator().notEmpty,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        controller: askingPriceController,
                        labelText: 'Asking Price',
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          return;
                        },
                        onSaved: (value) => askingPriceController.text = value!,
                        validator: Validator().number,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomDropdown2(
                        hintText: 'Condition',
                        dropdownItems: condition,
                        onChanged: (item) => cond.value = item!,
                        onSaved: (item) => cond.value = item!,
                        validator: (value) {
                          if (cond.value == '') {
                            return 'This is a required field';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        controller: brandController,
                        labelText: 'Brand (Optional)',
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          return;
                        },
                        onSaved: (value) => brandController.text = value!,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: CustomButton(
                          buttonColor: maroonColor,
                          text: 'Update',
                          onTap: () async {
                            if (_editFormkey.currentState!.validate()) {
                              await updateItem(item);
                              _editFormkey.currentState!.reset();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ]);
  }

  static Widget otpDialog(Item item, BuildContext context) {
    final _otpFormkey = GlobalKey<FormState>();
    final otpEditingController = TextEditingController();

    return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 20, horizontal: kIsWeb ? 30 : 5),
        children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [
                Text(
                  'To complete this transaction, please enter your OTP number to mark this item as sold',
                  textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(fontSize: 15),
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: _otpFormkey,
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Column(
                      children: [
                        InputField(
                          controller: otpEditingController,
                          labelText: 'OTP',
                          onChanged: (value) {
                            return;
                          },
                          onSaved: (value) =>
                              otpEditingController.text = value!,
                          validator: Validator().notEmpty,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: CustomButton(
                            buttonColor: maroonColor,
                            text: 'Submit',
                            onTap: () async {
                              if (_otpFormkey.currentState!.validate()) {
                                if (otpEditingController.text == item.otp) {
                                  await markItemAsSold(item);
                                  _otpFormkey.currentState!.reset();
                                } else {
                                  dismissDialog();
                                  showErrorDialog(
                                      errorTitle: 'Wrong OTP',
                                      errorDescription:
                                          'Please make sure to enter the correct OTP key for this item.');
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]);
  }

  static Widget reOpenItemDialog(String itemId, BuildContext context) {
    final RxBool showValidation = false.obs;
    return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 20, horizontal: kIsWeb ? 30 : 25),
        children: [
          Column(
            children: [
              Text(
                'To re-open item, please enter the following:',
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(fontSize: 15),
              ),
              const SizedBox(
                height: 20,
              ),
              dateTimeInput(context),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 120,
                height: 40,
                child: CustomButton(
                    buttonColor: maroonColor,
                    onTap: () async {
                      if (time.value.isNotEmpty && date.value.isNotEmpty) {
                        showValidation.value = false;
                        updateEndDate(itemId);
                        //Clear Inputted Data
                        date.value = '';
                        time.value = '';
                        dismissDialog();
                      } else {
                        showValidation.value = true;
                      }
                    },
                    text: 'Submit'),
              ),
              Obx(
                () => Visibility(
                  visible: showValidation.value,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Date and Time are required.',
                      style: robotoRegular.copyWith(
                        color: maroonColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ]);
  }

  static Widget dateTimeInput(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  color: whiteColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: getDate(context),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Obx(
                () => Text(date.value == '' ? 'Select Date' : date.value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  color: whiteColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: getTime(context),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Obx(
                () => Text(time.value == '' ? 'Select Time' : time.value),
              ),
            ),
          ],
        )
      ],
    );
  }

  static Widget getDate(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? selected = await showDatePicker(
          context: context,
          initialDate: selectedDate.value,
          firstDate: DateTime(2010),
          lastDate: DateTime(2025),
        );

        if (selected != null) {
          date.value = DateFormat.yMMMd().format(selected);
          selectedDate.value = selected;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 15 : 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.calendar_month,
              size: 20,
              color: blackColor,
            ),
            const SizedBox(
              width: kIsWeb ? 10 : 5,
            ),
            Flexible(
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

  static Widget getTime(BuildContext context) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: selectedTime.value,
          initialEntryMode: TimePickerEntryMode.dial,
        );
        if (timeOfDay != null) {
          time.value = timeOfDay.format(context);
          selectedTime.value = timeOfDay;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 15 : 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.schedule,
              size: 20,
              color: blackColor,
            ),
            const SizedBox(
              width: kIsWeb ? 10 : 5,
            ),
            Flexible(
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
}
