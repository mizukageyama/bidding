import 'package:bidding/controllers/auth_controller.dart';
import 'package:bidding/shared/components/_components.dart';
import 'package:bidding/shared/components/custom_radiobutton.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:bidding/shared/services/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.find();
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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  SizedBox(
                    width: 550,
                    height: 550,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: lightgreyColor,
                      margin: const EdgeInsets.all(20),
                      elevation: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          const ListTile(
                            title: Text(
                              'Welcome to Bidding Online!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const ListTile(
                            title: Text(
                              'Please choose user when logging in.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            child: CustomRadioButton(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FormInputFieldWithIcon(
                                      controller:
                                          authController.emailController,
                                      iconPrefix: Icons.email,
                                      labelText: 'Email',
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) {
                                        return;
                                      },
                                      onSaved: (value) => authController
                                          .emailController.text = value!,
                                      validator: Validator().email,
                                    ),
                                    const SizedBox(
                                      height: 25,
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
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          //  if (kIsWeb) {
                                          //  showDialog(
                                          //      context: context,
                                          //    builder: (context) =>
                                          //      forgotPassword(context));
                                          //    } else {
                                          //     Get.to(() => ForgotPasswordScreen());
                                          // }
                                        },
                                        style: TextButton.styleFrom(
                                            primary: lightblueColor),
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ])),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            buttonPadding: const EdgeInsets.symmetric(
                                horizontal: 45, vertical: 10),
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                                width: 110,
                                child: CustomButton(
                                  onTap: () {
                                    authController
                                        .signInWithEmailAndPassword(context);
                                  },
                                  text: 'Login',
                                  buttonColor: maroonColor,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                  height: 40,
                                  width: 110,
                                  child: CustomButton(
                                    onTap: () {},
                                    text: 'SignUp',
                                    buttonColor: maroonColor,
                                    fontSize: 16,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ])));
  }
}
