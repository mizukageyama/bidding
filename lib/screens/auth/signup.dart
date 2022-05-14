import 'dart:io';

import 'package:bidding/controllers/auth_controller.dart';
import 'package:bidding/screens/auth/login.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/constants/app_items.dart';
import 'package:bidding/shared/layout/styles.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final AuthController authcontroller = Get.find();
  final RxBool passwordObscure = true.obs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            )),
            child: SizedBox(
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: lightgreyColor,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 160, vertical: 70),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => {
                                //   Get.back(() => LoginScreen(),
                                // transition: Transition.noTransition)
                              },
                              child: const Icon(
                                Icons.arrow_back_outlined,
                                color: maroonColor,
                              ),
                            ),
                            const SizedBox(
                              width: 400,
                            ),
                            Text(
                              'Registration Form',
                              style: robotoBold.copyWith(
                                  color: blackColor, fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      child: Text(
                                        'Personal Details',
                                        style: robotoMedium.copyWith(
                                            color: blackColor, fontSize: 16),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 50,
                                            width: 250,
                                            child: CustomDropdown(
                                              hintText: 'Usertype',
                                              dropdownItems: usertype,
                                              onChanged: (item) =>
                                                  authcontroller
                                                      .usertype.value = item!,
                                              onSaved: (item) => authcontroller
                                                  .usertype.value = item!,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: 250,
                                            child: FormInputFieldWithIcon(
                                              controller: authcontroller
                                                  .idnumberController,
                                              iconPrefix: Icons.person,
                                              labelText: 'ID Number',
                                              keyboardType: TextInputType.name,
                                              onChanged: (value) {
                                                return;
                                              },
                                              onSaved: (value) => authcontroller
                                                  .idnumberController
                                                  .text = value!,
                                              validator: Validator().notEmpty,
                                            ),
                                          ),
                                        ]),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 250,
                                      child: FormInputFieldWithIcon(
                                        controller:
                                            authcontroller.firstNameController,
                                        iconPrefix: Icons.person,
                                        labelText: 'First tName',
                                        keyboardType: TextInputType.name,
                                        onChanged: (value) {
                                          return;
                                        },
                                        onSaved: (value) => authcontroller
                                            .firstNameController.text = value!,
                                        validator: Validator().notEmpty,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        height: 50,
                                        width: 250,
                                        child: FormInputFieldWithIcon(
                                          controller:
                                              authcontroller.lastNameController,
                                          iconPrefix: Icons.person,
                                          labelText: 'Last tName',
                                          keyboardType: TextInputType.name,
                                          onChanged: (value) {
                                            return;
                                          },
                                          onSaved: (value) => authcontroller
                                              .lastNameController.text = value!,
                                          validator: Validator().notEmpty,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        height: 50,
                                        width: 250,
                                        child: FormInputFieldWithIcon(
                                          controller:
                                              authcontroller.emailController,
                                          iconPrefix: Icons.mail,
                                          labelText: 'Email Address',
                                          keyboardType: TextInputType.name,
                                          onChanged: (value) {
                                            return;
                                          },
                                          onSaved: (value) => authcontroller
                                              .emailController.text = value!,
                                          validator: Validator().email,
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        height: 50,
                                        width: 250,
                                        child: Obx(
                                          () => FormInputFieldWithIcon(
                                            controller: authcontroller
                                                .passwordController,
                                            iconPrefix: Icons.lock,
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                passwordObscure.value =
                                                    !passwordObscure.value;
                                              },
                                              icon: Icon(
                                                passwordObscure.value
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                            ),
                                            labelText: 'Password',
                                            validator: Validator().password,
                                            obscureText: passwordObscure.value,
                                            onChanged: (value) {
                                              return;
                                            },
                                            onSaved: (value) => authcontroller
                                                .passwordController
                                                .text = value!,
                                            maxLines: 1,
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                        height: 50,
                                        width: 250,
                                        child: Obx(
                                          () => FormInputFieldWithIcon(
                                            controller: authcontroller
                                                .confirmPassController,
                                            iconPrefix: Icons.lock,
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                passwordObscure.value =
                                                    !passwordObscure.value;
                                              },
                                              icon: Icon(
                                                authcontroller
                                                        .isObscureText2!.value
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
                                                  authcontroller
                                                      .passwordController
                                                      .text) {
                                                return 'Password does not match';
                                              } else {
                                                return null;
                                              }
                                            },
                                            obscureText: authcontroller
                                                .isObscureText2!.value,
                                            onChanged: (value) {
                                              return;
                                            },
                                            onSaved: (value) => authcontroller
                                                .confirmPassController
                                                .text = value!,
                                            maxLines: 1,
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 310,
                                      width: 220,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: blackColor),
                                            color: whiteColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            )),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: LayoutBuilder(builder:
                                              (BuildContext context,
                                                  BoxConstraints constraints) {
                                            return Container(
                                              width: Get.width,
                                              color: whiteColor,
                                              child: Obx(getUMID),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      height: 310,
                                      width: 220,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: blackColor),
                                            color: whiteColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            )),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: LayoutBuilder(builder:
                                              (BuildContext context,
                                                  BoxConstraints constraints) {
                                            return Container(
                                              width: Get.width,
                                              color: whiteColor,
                                              child: Obx(getForm1),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ])
                        ]),
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          buttonPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                              width: 110,
                              child: CustomButton(
                                onTap: () {},
                                text: 'Clear Form',
                                buttonColor: maroonColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                                height: 40,
                                width: 110,
                                child: CustomButton(
                                  onTap: () {},
                                  text: 'Register',
                                  buttonColor: maroonColor,
                                  fontSize: 16,
                                )),
                          ],
                        )
                      ]),
                    )))));
  }

  Widget getUMID() {
    if (authcontroller.validIDImage.value == '') {
      return InkWell(
        onTap: authcontroller.pickForValidID,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_to_photos,
              size: 51,
              color: blackColor,
            ),
            const SizedBox(
              height: 5,
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
    return InkWell(
      onTap: authcontroller.pickForValidID,
      child: Stack(
        children: [
          kIsWeb
              ? Image.network(
                  authcontroller.validIDImage.value,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/default_image.png',
                        fit: BoxFit.cover);
                  },
                )
              : Image.file(
                  File(authcontroller.validIDImage.value),
                  width: Get.width,
                  height: Get.height,
                  fit: BoxFit.cover,
                ),
          Positioned(
            right: 5,
            top: 5,
            child: InkWell(
              onTap: () {
                authcontroller.validIDImage.value = '';
              },
              child: const Icon(
                Icons.remove_circle,
                size: 30,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getForm1() {
    if (authcontroller.form1Image.value == '') {
      return InkWell(
        onTap: authcontroller.pickForForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_to_photos,
              size: 51,
              color: blackColor,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Form 1',
              style: robotoBold.copyWith(color: blackColor, fontSize: 14),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
    return InkWell(
      onTap: authcontroller.pickForForm,
      child: Stack(
        children: [
          kIsWeb
              ? Image.network(
                  authcontroller.form1Image.value,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/default_image.png',
                        fit: BoxFit.cover);
                  },
                )
              : Image.file(
                  File(authcontroller.form1Image.value),
                  width: Get.width,
                  height: Get.height,
                  fit: BoxFit.cover,
                ),
          Positioned(
            right: 5,
            top: 5,
            child: InkWell(
              onTap: () {
                authcontroller.form1Image.value = '';
              },
              child: const Icon(
                Icons.remove_circle,
                size: 30,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
