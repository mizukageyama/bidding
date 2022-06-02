import 'dart:core';
import 'package:bidding/components/_components.dart';
import 'package:bidding/main/seller/controllers/add_item_controller.dart';
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
      //TO DO: Success Dialog
      titleController.clear();
      descriptionController.clear();
      brandController.clear();
      askingPriceController.clear();
      cond.value = '';
    });
  }

  //DELETE SELECTED AUCTIONED ITEM
  static Future<void> delete(String itemId) async {
    showLoading();
    await firestore
        .collection('items')
        .doc(itemId)
        .delete()
        .then((value) => deleteBids(itemId))
        .catchError((error) {
      dismissDialog();
      log.i("Failed to delete item");
    });
  }

  static Future<void> deleteBids(String itemId) async {
    try {
      firestore.collection('bids').get().then((snapshot) {
        List<DocumentSnapshot> allDocs = snapshot.docs;
        List<DocumentSnapshot> filteredDocs = allDocs.where((document) {
          final data = document.data() as Map<String, dynamic>;
          return data['item_id'] == itemId;
        }).toList();
        for (DocumentSnapshot ds in filteredDocs) {
          ds.reference.delete();
        }
      });
      dismissDialog();
      Get.back();
    } catch (e) {
      dismissDialog();
    }
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
                      CustomDropdown(
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
                          text: 'Update',
                          onTap: () async {
                            if (_editFormkey.currentState!.validate()) {
                              await updateItem(item);
                              _editFormkey.currentState!.reset();
                              dismissDialog();
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

  static Widget reOpenItemDialog(String itemId, BuildContext context) {
    final RxBool showValidation = false.obs;
    return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
            Text(
              'End Date of Auction',
              style: robotoBold.copyWith(color: blackColor, fontSize: 14),
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
            Text(
              'End Time of Auction',
              style: robotoBold.copyWith(color: blackColor, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
