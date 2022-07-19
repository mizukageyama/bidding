import 'package:bidding/firebase_options.dart';
import 'package:bidding/routes/app_pages.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'shared/controllers/all_controller_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AllControllerBinding(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.iNITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.noTransition,
    );
  }
}
