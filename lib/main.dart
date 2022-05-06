import 'package:bidding/constants/firebase_config.dart';
import 'package:bidding/constants/routes/app_pages.dart';
import 'package:bidding/controllers/all_controller_binding.dart';
import 'package:bidding/screens/seller/home.dart';
import 'package:bidding/screens/seller/add_item_form.dart';
import 'package:bidding/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AllControllerBinding(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
