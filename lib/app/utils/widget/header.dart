import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../data/controller/auth_controller.dart';
import '../../routes/app_pages.dart';
import '../style/AppColors.dart';

class header extends StatelessWidget {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 25),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Politeknik Takumi',
                style: TextStyle(fontSize: 30, color: AppColors.primaryText),
              ),
              Text(
                'ENTRUST THE FUTURE',
                style: TextStyle(fontSize: 16, color: AppColors.primaryText),
              ),
            ],
          ),
          const Spacer(flex: 1),
          Get.currentRoute == '/home'
              ? Expanded(
                  flex: 1,
                  child: TextField(
                    onChanged: (value) => authC.searchKaryawan(value),
                    controller: authC.searchKaryawanController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.only(left: 40, right: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintText: 'Search karyawan',
                    ),
                  ))
              : const SizedBox(),
          Obx(
            () => authC.isShow.isTrue
                ? Expanded(
                    flex: 1,
                    child: TextField(
                      onChanged: (value) => authC.searchAddKaryawan(value),
                      controller: authC.searchAddKaryawanController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.only(left: 40, right: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        hintText: 'Search add karyawan',
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(Ionicons.notifications,
              color: AppColors.primaryText, size: 30),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.defaultDialog(
                title: 'Sign Out',
                content: const Text('Are you sure want to sign out?'),
                cancel: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancle'),
                ),
                confirm: ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                  child: const Text('Sign Out'),
                ),
              );
            },
            child: Row(
              children: const [
                Text(
                  'Sign Out',
                  style: TextStyle(color: AppColors.primaryText, fontSize: 18),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Ionicons.log_out_outline,
                  color: AppColors.primaryText,
                  size: 30,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
