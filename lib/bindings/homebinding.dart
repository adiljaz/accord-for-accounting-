import 'package:accord/controler/homecontroller.dart';
import 'package:get/get.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}