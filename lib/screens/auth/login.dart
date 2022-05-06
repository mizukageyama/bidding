import 'package:bidding/controllers/auth_controller.dart';
import 'package:bidding/layout/styles.dart';
import 'package:bidding/services/validator.dart';
import 'package:bidding/layout/components/form_input_field_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  final RxBool passwordObscure = true.obs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 400,
        padding: const EdgeInsets.all(10.00),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: whiteColor,
          elevation: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              const ListTile(
                title: Text(
                  'Welcome to Bidding Online!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FormInputFieldWithIcon(
                          controller: authController.emailController,
                          iconPrefix: Icons.email,
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            return;
                          },
                          onSaved: (value) =>
                              authController.emailController.text = value!,
                          validator: Validator().email,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => FormInputFieldWithIcon(
                            controller: authController.passwordController,
                            iconPrefix: Icons.lock,
                            suffixIcon: IconButton(
                              onPressed: () {
                                passwordObscure.value = !passwordObscure.value;
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
                            onSaved: (value) =>
                                authController.passwordController.text = value!,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ])),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                children: <Widget>[
                  ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () {
                        authController.signInWithEmailAndPassword(context);
                      }),
                  ElevatedButton(child: const Text('SignUp'), onPressed: () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
