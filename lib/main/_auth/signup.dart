import 'dart:io';
import 'package:bidding/components/_components.dart';
import 'package:bidding/components/for_forms/custom_dropdown2.dart';
import 'package:bidding/components/terms_and_condition.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/controllers/auth_controller.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  final RxBool pwObscure = true.obs;
  final RxBool confirmPwObscure = true.obs;
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.all(kIsWeb ? 0 : 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: lightgreyColor,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kIsWeb ? 30 : 10,
                          horizontal: kIsWeb ? 20 : 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kIsWeb
                              ? const SizedBox(
                                  height: 0,
                                )
                              : const SizedBox(
                                  height: 10,
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.arrow_back_outlined,
                                  color: greyColor,
                                  size: kIsWeb ? 28 : 26,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Registration Form',
                                style: robotoBold.copyWith(
                                    color: blackColor,
                                    fontSize: kIsWeb ? 24 : 20),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: kIsWeb ? 50 : 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Personal Details',
                                  style: robotoMedium.copyWith(
                                      color: blackColor, fontSize: 15),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Form(
                                key: _registerFormKey,
                                child: Wrap(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: kIsWeb ? 20 : 10),
                                      width: 510,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 160,
                                                child: CustomDropdown2(
                                                  hintText: 'Select user type',
                                                  dropdownItems: userType,
                                                  onChanged: (item) =>
                                                      authController.userType
                                                          .value = item!,
                                                  onSaved: (item) =>
                                                      authController.userType
                                                          .value = item!,
                                                  validator: (value) {
                                                    if (authController
                                                            .userType.value ==
                                                        '') {
                                                      return 'This is a required field';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: InputField(
                                                  controller: authController
                                                      .idNumberController,
                                                  labelText: 'ID Number',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    return;
                                                  },
                                                  onSaved: (value) =>
                                                      authController
                                                          .idNumberController
                                                          .text = value!,
                                                  validator:
                                                      Validator().notEmpty,
                                                  hideLabelTyping: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          FormInputFieldWithIcon(
                                            capitalizedFirst: true,
                                            controller: authController
                                                .firstNameController,
                                            iconPrefix: Icons.person,
                                            labelText: 'First Name',
                                            keyboardType: TextInputType.name,
                                            onChanged: (value) {
                                              return;
                                            },
                                            onSaved: (value) => authController
                                                .firstNameController
                                                .text = value!,
                                            validator: Validator().notEmpty,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          FormInputFieldWithIcon(
                                            capitalizedFirst: true,
                                            controller: authController
                                                .lastNameController,
                                            iconPrefix: Icons.person,
                                            labelText: 'Last Name',
                                            keyboardType: TextInputType.name,
                                            onChanged: (value) {
                                              return;
                                            },
                                            onSaved: (value) => authController
                                                .lastNameController
                                                .text = value!,
                                            validator: Validator().notEmpty,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          FormInputFieldWithIcon(
                                            controller: authController
                                                .contactController,
                                            iconPrefix: Icons.contact_phone,
                                            labelText: 'Contact Number',
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              return;
                                            },
                                            onSaved: (value) => authController
                                                .contactController
                                                .text = value!,
                                            validator: Validator().number,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          FormInputFieldWithIcon(
                                            controller:
                                                authController.emailController,
                                            iconPrefix: Icons.mail,
                                            labelText: 'Email Address',
                                            keyboardType: TextInputType.name,
                                            onChanged: (value) {
                                              return;
                                            },
                                            onSaved: (value) => authController
                                                .emailController.text = value!,
                                            validator: Validator().email,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Obx(
                                            () => FormInputFieldWithIcon(
                                              controller: authController
                                                  .passwordController,
                                              iconPrefix: Icons.lock,
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  pwObscure.value =
                                                      !pwObscure.value;
                                                },
                                                icon: Icon(
                                                  pwObscure.value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                              ),
                                              labelText: 'Password',
                                              validator: Validator().password,
                                              obscureText: pwObscure.value,
                                              onChanged: (value) {
                                                return;
                                              },
                                              onSaved: (value) => authController
                                                  .passwordController
                                                  .text = value!,
                                              maxLines: 1,
                                              textInputAction:
                                                  TextInputAction.done,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Obx(
                                            () => FormInputFieldWithIcon(
                                              iconPrefix: Icons.lock,
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  confirmPwObscure.value =
                                                      !confirmPwObscure.value;
                                                },
                                                icon: Icon(
                                                  confirmPwObscure.value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                              ),
                                              labelText: 'Confirm Password',
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'This is a required field';
                                                }
                                                if (value !=
                                                    authController
                                                        .passwordController
                                                        .text) {
                                                  return 'Password does not match';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              obscureText:
                                                  confirmPwObscure.value,
                                              onChanged: (value) {
                                                return;
                                              },
                                              maxLines: 1,
                                              textInputAction:
                                                  TextInputAction.done,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: kIsWeb ? 20 : 10),
                                      width: 520,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  height: kIsWeb ? 310 : 240,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      color: whiteColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(12),
                                                      )),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  12)),
                                                      child: Obx(getUMID)),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: kIsWeb ? 30 : 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: kIsWeb ? 310 : 240,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      color: whiteColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(12),
                                                      )),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  12)),
                                                      child: Obx(getForm1)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          CheckboxFormField(
                                            callback: () => showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    tACDialog(context)),
                                            title: Row(
                                              children: [
                                                Text(
                                                  'I agree to ',
                                                  style: robotoRegular.copyWith(
                                                      fontSize:
                                                          kIsWeb ? 13 : 15,
                                                      color: blackColor),
                                                ),
                                                Text(
                                                  'Terms & Condition',
                                                  style: robotoMedium.copyWith(
                                                      fontSize:
                                                          kIsWeb ? 13 : 15,
                                                      color: lightblueColor),
                                                ),
                                              ],
                                            ),
                                            validator: (value) {
                                              if (!value!) {
                                                return 'This is a required field';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: 110,
                                                child: CustomButton(
                                                  onTap: () {
                                                    _registerFormKey
                                                        .currentState!
                                                        .reset();
                                                    authController
                                                        .userType.value = '';
                                                    authController
                                                        .idImage.value = '';
                                                    authController
                                                        .form1Image.value = '';
                                                  },
                                                  text: kIsWeb
                                                      ? 'Clear Form'
                                                      : 'Clear',
                                                  buttonColor: maroonColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                height: 40,
                                                width: 110,
                                                child: CustomButton(
                                                  onTap: () {
                                                    if (_registerFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      authController
                                                          .submitRegistration(
                                                              context);
                                                    }
                                                  },
                                                  text: 'Register',
                                                  buttonColor: maroonColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
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
            ],
          ),
        ),
      ),
    );
  }

  Widget tACDialog(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 40,
      ),
      children: const [TermsAndCondition()],
    );
  }

  Widget getUMID() {
    if (authController.idImage.value == '') {
      return InkWell(
        onTap: authController.pickImageID,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_to_photos,
              size: 51,
              color: blackColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Add UM ID',
              style: robotoBold.copyWith(color: blackColor, fontSize: 14),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: kIsWeb
              ? Image.network(
                  authController.idImage.value,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/default_image.png',
                        fit: BoxFit.cover);
                  },
                )
              : Image.file(
                  File(authController.idImage.value),
                  width: Get.width,
                  height: Get.height,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: InkWell(
            onTap: () {
              authController.idImage.value = '';
            },
            child: const Icon(
              Icons.remove_circle,
              size: 30,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget getForm1() {
    if (authController.form1Image.value == '') {
      return InkWell(
        onTap: authController.pickImageForm1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_to_photos,
              size: 51,
              color: blackColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Add Form 1',
              style: robotoBold.copyWith(color: blackColor, fontSize: 14),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: kIsWeb
              ? Image.network(
                  authController.form1Image.value,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/default_image.png',
                        fit: BoxFit.cover);
                  },
                )
              : Image.file(
                  File(authController.form1Image.value),
                  width: Get.width,
                  height: Get.height,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: InkWell(
            onTap: () {
              authController.form1Image.value = '';
            },
            child: const Icon(
              Icons.remove_circle,
              size: 30,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
