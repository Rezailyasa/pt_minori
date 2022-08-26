import 'package:get/get.dart';

import '../controllers/training_controller.dart';

class TrainingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingController>(
      () => TrainingController(),
    );
  }
}
