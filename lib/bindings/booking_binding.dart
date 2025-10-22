import 'package:commv/controllers/book_order_controller.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookOrderController>(() => BookOrderController());
  }
}