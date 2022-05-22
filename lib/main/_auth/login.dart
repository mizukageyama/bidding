import 'package:bidding/components/_components.dart';
import 'package:bidding/main/_auth/_auth_screens.dart';
import 'package:bidding/shared/controllers/auth_controller.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  final RxBool passwordObscure = true.obs;
  final _loginFormKey = GlobalKey<FormState>();

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
        )),
        child: Center(
          child: SizedBox(
            width: 530,
            child: ListView(
              shrinkWrap: true,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: lightgreyColor,
                  margin: const EdgeInsets.all(20),
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 45),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Welcome to Bidding Online!',
                          textAlign: TextAlign.center,
                          style: robotoBold.copyWith(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Form(
                          key: _loginFormKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kIsWeb ? 50 : 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormInputFieldWithIcon(
                                  controller: authController.emailController,
                                  iconPrefix: Icons.email,
                                  labelText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    return;
                                  },
                                  onSaved: (value) => authController
                                      .emailController.text = value!,
                                  validator: Validator().notEmpty,
                                  hideLabelTyping: true,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Obx(
                                  () => FormInputFieldWithIcon(
                                    controller:
                                        authController.passwordController,
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
                                    onSaved: (value) => authController
                                        .passwordController.text = value!,
                                    maxLines: 1,
                                    textInputAction: TextInputAction.done,
                                    hideLabelTyping: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              forgotPassword(context));
                                    },
                                    style: TextButton.styleFrom(
                                        primary: Colors.blue),
                                    child: Text('Forgot Password?',
                                        style: robotoMedium.copyWith(
                                          fontSize: kIsWeb ? 12 : 15,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: CustomButton(
                                    onTap: () {
                                      if (_loginFormKey.currentState!
                                          .validate()) {
                                        authController
                                            .signInWithEmailAndPassword(
                                                context);
                                      }
                                    },
                                    text: 'Login',
                                    buttonColor: maroonColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: CustomButton(
                                    onTap: () {
                                      Get.to(() => SignupScreen());
                                    },
                                    text: 'Sign Up',
                                    buttonColor: maroonColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forgotPassword(BuildContext context) {
    final _forgotPwFormKey = GlobalKey<FormState>();
    return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: kIsWeb ? 50 : 30,
        ),
        children: [
          Form(
            key: _forgotPwFormKey,
            child: SizedBox(
              width: kIsWeb ? Get.width * .2 : Get.width * .9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Recover Password',
                    style: robotoBold.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Help us recover your password. Enter your registered email then enter the code 6-digit code.',
                    style: TextStyle(
                      fontSize: 15,
                      color: greyColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormInputFieldWithIcon(
                    controller: authController.emailController,
                    iconPrefix: Icons.email,
                    labelText: 'Email',
                    validator: Validator().email,
                    onChanged: (value) {
                      return;
                    },
                    onSaved: (value) =>
                        authController.emailController.text = value!,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 40,
                    width: 100,
                    child: CustomButton(
                      onTap: () async {
                        if (_forgotPwFormKey.currentState!.validate()) {
                          await authController.sendPasswordResetEmail(context);
                        }
                      },
                      text: 'Request Password Reset',
                      buttonColor: maroonColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ]);
  }
}
