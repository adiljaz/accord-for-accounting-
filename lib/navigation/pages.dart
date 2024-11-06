import 'package:accord/bindings/addinvoicebinding.dart';
import 'package:accord/screen/home/home.dart';
import 'package:accord/bindings/homebinding.dart';
import 'package:accord/screen/invoiceadd/invoice.dart';
import 'package:accord/screen/invoiceview/invoiceview.dart';
import 'package:accord/screen/splash/splash.dart';
import 'package:accord/bindings/splashbindingg.dart';
import 'package:accord/bindings/viewinvoicebinding.dart';
import 'package:get/get.dart';


class AppPages {
  // ignore: constant_identifier_names
  static const INITIAL = '/splash';

  static final routes = [
    GetPage(
      name: '/splash',
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/add-invoice',
      page: () => const AddInvoiceView(),
      binding: AddInvoiceBinding(),
    ),
    GetPage( 
      name: '/view-invoice',
      page: () => ViewInvoiceView(),
      binding: ViewInvoiceBinding(),
    ),
  ];
} 