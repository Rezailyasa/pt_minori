import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../data/controller/auth_controller.dart';
import '../style/AppColors.dart';

addTraining({BuildContext? context, String? type, String? docId}) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$type training',
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 10,
              ), //nama lengkap
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Jenis training',
                  hintText: 'Jenis training',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: authC.jenisTrainingController,
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
              DateTimePicker(
                decoration: InputDecoration(
                  labelText: 'Tanggal sertifikat',
                  hintText: 'Tanggal sertifikat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Ionicons.calendar_clear_outline),
                ),

                // initialValue: controller.dateController.text,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                controller: authC.tanggalSertifikatController,
                onChanged: (val) => print(val),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (val) => print(val),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                  hintText: 'Keterangan',
                  hintMaxLines: 4,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 4,
                controller: authC.keteranganController,
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
                  label: Text(
                    type!,
                  ),
                  onPressed: () {
                    authC.saveTraining(
                      type,
                      authC.jenisTrainingController.text,
                      authC.tanggalSertifikatController.text,
                      authC.keteranganController.text,
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
