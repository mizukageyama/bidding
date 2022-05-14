import 'package:bidding/controllers/auth_controller.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';

class AddItemFormController extends GetxController {
  final log = getLogger('Add Item Form Controller');
  static AuthController authController = Get.find();

  TextEditingController titleNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController askingPriceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController enddateofauctionController = TextEditingController();

  final RxString category = ''.obs;
  final RxString condition = ''.obs;

  XFile? imgOfItemFile;
  final RxList<XFile> itemImages = RxList<XFile>();
  final ImagePickerService itemPicker = ImagePickerService();

  final uuid = const Uuid();

  // bool hasIDSelected() {
  //   if (imgOfItemFile != '') {
  //     return true;
  //   }
  //   return false;
  // }

  Future<void> addItemSale(String userID) async {
    log.i('Saving item sale data on id: $userID');

    final String generatedItemId = uuid.v4();

    await firestore.collection('items').doc(generatedItemId).set({
      'item_id': generatedItemId,
      //'seller_id':
      'title': titleNameController.text.trim(),
      'description': descriptionController.text.trim(),
      'asking_price': askingPriceController.text,
      'brand': brandController.text,
      'end_date': enddateofauctionController.text,
      'category': category.value,
      'condition': condition.value,
    });
  }

  Future<void> clearControllers() async {
    log.i('_clearControllers | User Input on Item form is cleared');
    titleNameController.clear();
    descriptionController.clear();
    askingPriceController.clear();
    brandController.clear();
    category.value = '';
    condition.value = '';
  }

  void pickForItemSale() {
    itemPicker.pickMultiImage(itemImages);
  }
}
