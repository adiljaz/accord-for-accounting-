import 'package:accord/controler/viewinvoicecontroller.dart';
import 'package:get/get.dart';


class ViewInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ViewInvoiceController());
  }
}