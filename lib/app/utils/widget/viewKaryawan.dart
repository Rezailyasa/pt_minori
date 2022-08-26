import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/controller/auth_controller.dart';
import '../style/AppColors.dart';

viewKaryawan({
  BuildContext? context,
  String? email,
  String? photo,
  String? nip,
  String? name,
}) {
  final authC = Get.find<AuthController>();

  Get.bottomSheet(
    SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        margin: context!.isPhone
            ? EdgeInsets.zero
            : const EdgeInsets.only(left: 150, right: 150),
        // height: Get.height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Form(
          key: authC.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              //nama lengkap
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'NIP',
                  hintText: 'NIP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: authC.nipController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Nama Lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: authC.displayNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              //tempat lahir
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Jabatan',
                  hintText: 'Jabatan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: authC.jabatanController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: Get.context!.width, height: 45),
                child: FloatingActionButton.extended(
                  label: const Text(
                    "Update",
                  ),
                  onPressed: () {
                    authC.saveBiodata(
                      authC.nipController.text,
                      authC.displayNameController.text,
                      authC.jabatanController.text,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
