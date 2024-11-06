import 'package:accord/controler/addinvoicecontroller.dart';
import 'package:get/get.dart';


class  AddInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddInvoiceController());
  }
}