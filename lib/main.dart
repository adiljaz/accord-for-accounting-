import 'package:accord/controler/addinvoicecontroller.dart';
import 'package:accord/firebase_options.dart';
import 'package:accord/navigation/pages.dart';
import 'package:accord/theme/teheme.dart';
import 'package:accord/controler/viewinvoicecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only initialize Firebase if it hasn't been initialized before

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Accord Invoice',
      theme: ThemeManager.lightTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => AddInvoiceController(), fenix: true);
        Get.lazyPut(() => ViewInvoiceController(), fenix: true);
      }),
    );
  }
}
