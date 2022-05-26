import 'package:bidding/shared/controllers/_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
            child: Text(
          'Bidding Splash Screen',
        )),
      ),
    );
  }
}
