import 'package:bidding/components/_components.dart';
import 'package:bidding/main/seller/controllers/seller_side_menu_controller.dart';
import 'package:bidding/main/seller/screens/_seller_screens.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:bidding/shared/services/image_upload.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddItemController extends GetxController {
  final log = getLogger('Add Item Form Controller');

  static final AuthController authController = Get.find();
  final UserModel user = authController.userModel.value!;
  final ImagePickerService itemPicker = ImagePickerService();
  final uuid = const Uuid();

  //Input Data From Item Form
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController askingPriceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController addOnCategory = TextEditingController();
  final RxSet<String> category = <String>{}.obs;
  final RxString condition = ''.obs;

  //Date and Time Input
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  final RxString time = ''.obs;
  final RxString date = ''.obs;

  //Images
  final RxList<XFile> itemImages = RxList<XFile>();
  final RxList<String> itemImageUrls = RxList.empty(growable: true);

  Future<void> postItem(GlobalKey<FormState> key) async {
    if (itemImages.isNotEmpty) {
      if (date.isEmpty || time.isEmpty) {
        showSimpleDialog(
          title: 'All fields are required',
          description:
              'Please provide end date and time for your item to auction.',
          onTapFunc: () => dismissDialog(),
        );
      } else {
        final bool result = await addItemSale();
        if (result) {
          key.currentState!.reset();
          clearControllers();
          SellerSideMenuController menu = Get.find();
          menu.changeActiveItem('Auctioned Items');
          Get.to(() => const AuctionedItemListScreen());
        } else {
          showSimpleDialog(
            title: 'Add Item for Auction Failed',
            description: 'An error occurred. Please try again later.',
            onTapFunc: () => dismissDialog(),
          );
        }
      }
    } else {
      showSimpleDialog(
        title: 'All fields are required',
        description: 'Please provide photos of your item.',
        onTapFunc: () => dismissDialog(),
      );
    }
  }

  DateTime endDateValue() {
    final TimeOfDay t = selectedTime.value;
    final DateTime d = selectedDate.value;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  Future<bool> addItemSale() async {
    //log.i('Saving item sale data on id: ${user.userID}');

    final RxBool successWrite = true.obs;

    showLoading();
    final String generatedItemId = uuid.v4();
    final bool uploadingSuccess = await uploadImages(generatedItemId);
    if (uploadingSuccess) {
      log.i('uploading success');
      Timestamp endTimeStamp = Timestamp.fromDate(endDateValue());

      await firestore.collection('items').doc(generatedItemId).set({
        'item_id': generatedItemId,
        'seller_id': user.userID,
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'asking_price': double.parse(askingPriceController.text),
        'brand': brandController.text,
        'date_posted': Timestamp.now(),
        'end_date': endTimeStamp,
        'category': List<String>.from(category),
        'condition': condition.value,
        'images': itemImageUrls,
      }).catchError((error) {
        log.i(error);

        dismissDialog();
        successWrite.value = false;
      });
    } else {
      dismissDialog();
      return false;
    }
    dismissDialog();
    return successWrite.value;
  }

  Future<bool> uploadImages(String id) async {
    final String directory = 'item_images/$id/';
    if (kIsWeb) {
      itemImageUrls.addAll(await Upload.multiImageWeb(
        images: itemImages,
        saveAs: directory,
      ));
    } else {
      itemImageUrls.addAll(await Upload.multiImage(
        images: itemImages,
        saveAs: directory,
      ));
    }
    if (itemImageUrls.isNotEmpty) {
      return true;
    }
    return false;
  }

  void pickForItemSale() {
    itemPicker.pickMultiImage(itemImages);
  }

  Future<void> clearControllers() async {
    log.i('_clearControllers | User Input on Item form is cleared');
    titleController.clear();
    descriptionController.clear();
    askingPriceController.clear();
    brandController.clear();
    category.clear();
    condition.value = '';
    time.value = '';
    date.value = '';
    itemImageUrls.clear();
    itemImages.clear();
  }

  void addOnImages() async {
    final RxList<XFile> addOn = RxList<XFile>();
    await itemPicker.pickMultiImage(addOn);
    final int leftCount = 10 - itemImages.length;
    final addOnLimited = RxList<XFile>.from(
        addOn.getRange(0, addOn.length > leftCount ? leftCount : addOn.length));
    itemImages.addAll(addOnLimited);
  }

  Widget inputDialog() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Please enter a category',
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  controller: addOnCategory,
                  validator: Validator().notEmpty,
                  maxLines: 1,
                  labelText: 'Category',
                  onChanged: (value) {},
                  onSaved: (value) {},
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: CustomButton(
                      buttonColor: maroonColor,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          category.add(addOnCategory.text.trim());
                          _formKey.currentState!.reset();
                          dismissDialog();
                        }
                      },
                      text: 'Add'),
                ),
              ],
            ),
          )
        ]);
  }
}
