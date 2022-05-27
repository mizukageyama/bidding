import 'package:bidding/components/_components.dart';
import 'package:bidding/main/bidder/side_menu.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/controllers/profile_controller.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/layout/mobile_body_sliver.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: BidderSideMenu(),
        body: ResponsiveView(
          _Content(),
          MobileSliver(
            title: 'Profile',
            body: _Content(),
          ),
          BidderSideMenu(),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({Key? key}) : super(key: key);

  final ProfileController profileController = Get.find();
  final RxBool currentpwObscure = true.obs;
  final RxBool newPwObscure = true.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: whiteColor,
      child: Column(children: [
        kIsWeb && Get.width >= 600
            ? Container(
                color: maroonColor,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Profile',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: whiteColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
                width: 0,
              ),
        Expanded(
          child: ListView(
              padding: const EdgeInsets.all(15),
              shrinkWrap: true,
              children: [
                Wrap(alignment: WrapAlignment.center, children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: kIsWeb ? 50 : 40),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: whiteColor,
                      borderOnForeground: true,
                      shadowColor: brownColor,
                      margin: const EdgeInsets.all(15),
                      elevation: 3,
                      child: Container(
                        width: kIsWeb ? Get.width * .4 : Get.width * .8,
                        padding: const EdgeInsets.symmetric(
                            vertical: 45, horizontal: 5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              displayProfile(),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                profileController.role,
                                style: robotoBold.copyWith(
                                  color: orangeColor,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                profileController.email,
                                style: robotoLight.copyWith(
                                  color: blackColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                profileController.fullName,
                                style: robotoMedium.copyWith(
                                  color: blackColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          changePassword(context));
                                },
                                icon: const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    primary: maroonColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 17),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                label: const Text('Change Password'),
                              )
                            ]),
                      ),
                    ),
                  )
                ]),
              ]),
        ),
      ]),
    );
  }

  Widget displayProfile() {
    // return StreamBuilder<DocumentSnapshot>(
    //     // stream: profileController.profilePhoto(),
    //     builder: (context, snapshot) {
    //   if (snapshot.connectionState == ConnectionState.waiting) {
    //     return const CircleImage(
    //       assetImage: 'assets/images/default_image.png',
    //     );
    //   }
    //   if (snapshot.hasError || !snapshot.hasData) {
    //     return const CircleImage(
    //       assetImage: 'assets/images/default_image.png',
    //     );
    //   }
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: CircleImage(
            height: kIsWeb ? 125 : 130,
            width: kIsWeb ? 125 : 130,
            imageUrl: '${profileController.profilePhoto}',
          ),
        ),
        Positioned(
            bottom: 0,
            right: kIsWeb ? 05 : 04,
            child: ClipOval(
              child: Material(
                color: orangeColor,
                child: InkWell(
                  onTap: () {
                    profileController.selectProfileImage();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Colors.white,
                        size: kIsWeb ? 25 : 15,
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
    //});
  }

  Widget changePassword(BuildContext context) {
    final _changePassword = GlobalKey<FormState>();
    return Center(
        child: SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      children: [
        SizedBox(
          width: kIsWeb ? Get.width * .3 : Get.width * .7,
          child: Column(children: [
            Text(
              'Change Password',
              style: robotoBold.copyWith(color: blackColor, fontSize: 20),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Please provide your current password and your new password.',
              style: robotoLight.copyWith(color: greyColor, fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: _changePassword,
              child: SizedBox(
                width: kIsWeb ? Get.width * .2 : Get.width * .9,
                child: Column(children: [
                  Obx(
                    () => FormInputFieldWithIcon(
                      controller: profileController.currentPwController,
                      iconPrefix: Icons.lock,
                      suffixIcon: IconButton(
                        onPressed: () {
                          currentpwObscure.value = !currentpwObscure.value;
                        },
                        icon: Icon(
                          currentpwObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      labelText: 'Current Password',
                      validator: Validator().password,
                      obscureText: currentpwObscure.value,
                      onChanged: (value) {
                        return;
                      },
                      onSaved: (value) =>
                          profileController.currentPwController.text = value!,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => FormInputFieldWithIcon(
                      controller: profileController.newPwController,
                      iconPrefix: Icons.lock,
                      suffixIcon: IconButton(
                        onPressed: () {
                          newPwObscure.value = !newPwObscure.value;
                        },
                        icon: Icon(
                          newPwObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      labelText: 'New Password',
                      validator: Validator().password,
                      obscureText: newPwObscure.value,
                      onChanged: (value) {
                        return;
                      },
                      onSaved: (value) =>
                          profileController.newPwController.text = value!,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 160,
              height: 40,
              child: CustomButton(
                onTap: () async {
                  await profileController.changePassword(context);
                },
                text: 'Save Password',
                buttonColor: maroonColor,
              ),
            )
          ]),
        )
      ],
    ));
  }
}
