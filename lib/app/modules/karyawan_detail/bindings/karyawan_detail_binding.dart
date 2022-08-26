import 'package:get/get.dart';

import '../controllers/karyawan_detail_controller.dart';

class KaryawanDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanDetailController>(
      () => KaryawanDetailController(),
    );
  }
}
