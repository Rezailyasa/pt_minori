import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/karyawan_detail/bindings/karyawan_detail_binding.dart';
import '../modules/karyawan_detail/views/karyawan_detail_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/training/bindings/training_binding.dart';
import '../modules/training/views/training_view.dart';
import '../modules/training_peserta/bindings/training_peserta_binding.dart';
import '../modules/training_peserta/views/training_peserta_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.TRAINING,
      page: () => TrainingView(),
      binding: TrainingBinding(),
    ),
    GetPage(
      name: _Paths.TRAINING_PESERTA,
      page: () => TrainingPesertaView(),
      binding: TrainingPesertaBinding(),
    ),
    GetPage(
      name: _Paths.KARYAWAN_DETAIL,
      page: () => KaryawanDetailView(),
      binding: KaryawanDetailBinding(),
    ),
  ];
}
