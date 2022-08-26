import 'package:get/get.dart';

import '../controllers/training_peserta_controller.dart';

class TrainingPesertaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainingPesertaController>(
      () => TrainingPesertaController(),
    );
  }
}
