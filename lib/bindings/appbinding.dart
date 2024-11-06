import 'package:accord/firebasesurivce.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseService());
  }
}