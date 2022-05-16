import 'package:bidding/controllers/auth_controller.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';

class AddItemFormController extends GetxController {
  final log = getLogger('Add Item Form Controller');

  static AuthController authController = Get.find();

  //Input Data From Item Form
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController askingPriceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController enddateofauctionController = TextEditingController();
  final RxList<XFile> itemImages = RxList<XFile>();
  final RxString category = ''.obs;
  final RxString condition = ''.obs;

  //images
  XFile? imgItemFile;
  final RxString itemImageUrl = ''.obs;
  final RxString listitemImgURL = ''.obs;
  final ImagePickerService itemPicker = ImagePickerService();

  final uuid = const Uuid();

  // Future<void> postItem(BuildContext context) async {
  //   if (hasitemImagesSelected()) {
  //     log.i('Post Item');
  //     await uploadItemImgs();
  //     await addItemSale();
  //   } else {
  //     log.i('Please select Image');
  //   }
  // }

  Future<void> addItemSale() async {
    // log.i('Saving item sale data on id: $_userID');

    final String generatedItemId = uuid.v4();

    await firestore.collection('items').doc(generatedItemId).set({
      'item_id': generatedItemId,
      'seller_id': '',
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'asking_price': askingPriceController.text,
      'brand': brandController.text,
      'end_date': enddateofauctionController.text,
      'category': category.value,
      'condition': condition.value,
      'images': itemImageUrl.value,
    });
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
    category.value = '';
    condition.value = '';
  }

  void addOnImages() async {
    final RxList<XFile> addOn = RxList<XFile>();
    await itemPicker.pickMultiImage(addOn);
    final int leftCount = 10 - itemImages.length;
    final addOnLimited = RxList<XFile>.from(addOn.getRange(0, leftCount));
    itemImages.addAll(addOnLimited);
  }
}
