import 'package:bidding/components/_components.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:bidding/shared/layout/styles.dart';

void showLoading() {
  Get.defaultDialog(
      title: 'Loading...',
      content: const CircularProgressIndicator(),
      barrierDismissible: false);
}

void showErrorDialog({
  String? errorTitle,
  String? errorDescription,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: kIsWeb ? 400 : Get.width * .9,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        margin: const EdgeInsets.only(top: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              errorTitle!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                errorDescription!,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: neutralColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 130,
              child: ErrorDialogButton(
                buttonText: 'Got it!',
                onTap: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void getBack() {
  Get.back();
}

void showSimpleDialog({
  String? title,
  String? description = '',
  void Function()? onTapFunc = getBack,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: kIsWeb ? 400 : Get.width * .9,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        margin: const EdgeInsets.only(top: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                title!,
                style: robotoBold.copyWith(
                  fontSize: 15,
                  color: brownColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            description == ''
                ? const SizedBox(
                    height: 10,
                    width: 0,
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      description!,
                      style: robotoRegular.copyWith(
                        fontSize: 14,
                        color: greyColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
            SizedBox(
              width: 130,
              child: ErrorDialogButton(
                buttonText: 'Got it',
                onTap: onTapFunc,
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

void showDefaultDialog({
  String? dialogTitle,
  String? dialogCaption,
  String? textConfirm = 'Got it!',
  void Function()? onConfirmTap,
}) {
  Get.defaultDialog(
    barrierDismissible: false,
    radius: 8,
    titleStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    titlePadding: const EdgeInsets.all(10),
    title: dialogTitle!,
    content: Text(
      dialogCaption!,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: neutralColor),
      textAlign: TextAlign.center,
    ),
    onConfirm: onConfirmTap,
    textConfirm: textConfirm,
    confirmTextColor: Colors.white,
  );
}

void showDefaultDialogWithText({
  String? dialogTitle,
  String? dialogCaption,
  String? textConfirm,
  void Function()? onConfirmTap,
}) {
  Get.defaultDialog(
    barrierDismissible: false,
    radius: 8,
    titleStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    titlePadding: const EdgeInsets.all(10),
    title: dialogTitle!,
    content: Text(
      dialogCaption!,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: neutralColor),
      textAlign: TextAlign.center,
    ),
    onConfirm: onConfirmTap,
    textConfirm: textConfirm,
    confirmTextColor: Colors.white,
  );
}

void showConfirmationDialog({
  required String dialogTitle,
  required String dialogCaption,
  required Function() onYesTap,
  required Function() onNoTap,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            width: kIsWeb ? 400 : Get.width * .9,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
            margin: const EdgeInsets.only(top: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  dialogTitle,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    dialogCaption,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: neutralColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DialogButton(
                          buttonText: 'dialogbtn1'.tr,
                          onTap: onYesTap,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: DialogButton(
                          buttonText: 'dialogbtn01'.tr,
                          onTap: onNoTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 20,
            child: GestureDetector(
              onTap: Get.back,
              child: const Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFFE3E6E8),
                  child: Icon(
                    Icons.close,
                    color: neutralColor,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}

void dismissDialog() {
  Get.back();
}
