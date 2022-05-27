import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileController extends GetxController {
  final log = getLogger('Profile Controller');
  final ImagePickerService imagePicker = ImagePickerService();
  final AuthController authController = Get.find();

  //Change pfp
  XFile? imageSelected;
  RxString imagePath = ''.obs;
  RxString url = ''.obs;

  //Change pw
  TextEditingController currentPwController = TextEditingController();
  TextEditingController newPwController = TextEditingController();
  RxBool? isObscureCurrentPW = true.obs;
  RxBool? isObscureNewPW = true.obs;

  void selectProfileImage() async {
    imageSelected = await imagePicker.pickImageOnWeb(imagePath);
    if (imageSelected != null || imagePath.value != '') {
      showLoading();
      await uploadImageWeb();
    }
  }

  Future<void> uploadImageWeb() async {
    final fileBytes = imageSelected!.readAsBytes();
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': imagePath.value});
    final ref = storageRef.child('user/${auth.currentUser!.uid}/Profile-photo');
    final uploadTask = ref.putData(await fileBytes, metadata);
    await uploadTask.then((res) async {
      url.value = await res.ref.getDownloadURL();
      await updateProfile();
    });
  }

  Future<void> updateProfile() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('additional_info')
        .doc('value')
        .update({
      'profile_photo': url.value,
    }).then((value) {
      dismissDialog();
    }).catchError((onError) {
      dismissDialog();
      showErrorDialog(
          errorTitle: 'Something went wrong',
          errorDescription: 'Sorry, please try again later.');
    });
  }

  //Change password
  Future<void> changePassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPwController.text);
    showLoading();
    await user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPwController.text).then((_) {
        dismissDialog();
        _changePasswordSuccess();
        Get.back();
        Get.snackbar('Password Changed Successfully',
            'You may now use your new password.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      });
    }).catchError((err) {
      dismissDialog();
      Get.snackbar('Password Change Failed',
          'Your current password you have entered is not correct',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    });
  }

  Future<void> _changePasswordSuccess() async {
    log.i('_clearControllers | Change Password Success');
    currentPwController.clear();
    newPwController.clear();
    isObscureCurrentPW!.value = true;
    isObscureNewPW!.value = true;
  }
}
