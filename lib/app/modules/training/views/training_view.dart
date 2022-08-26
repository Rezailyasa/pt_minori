import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pt_minori/app/utils/widget/addTraining.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../utils/style/AppColors.dart';
import '../../../utils/widget/header.dart';
import '../../../utils/widget/sideBar.dart';
import '../controllers/training_controller.dart';

class TrainingView extends GetView<TrainingController> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final authC = Get.find<AuthController>();
  String edit = 'Edit';
  String delete = 'Delete';

  @override
  Widget build(BuildContext context) {
    authC.getUser();
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 150, child: SideBar()),
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        child: Row(
          children: [
            !context.isPhone
                ? Expanded(
                    flex: 2,
                    child: SideBar(),
                  )
                : const SizedBox(),
            Expanded(
              flex: 15,
              child: Column(children: [
                !context.isPhone
                    ? header()
                    : Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _drawerKey.currentState!.openDrawer();
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Politeknik Takumi',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.primaryText),
                                ),
                                Text(
                                  'ENTRUST THE FUTURE',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryText),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Ionicons.notifications,
                              color: AppColors.primaryText,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 25,
                                foregroundImage: NetworkImage(
                                    authC.auth.currentUser!.photoURL!),
                              ),
                            )
                          ],
                        ),
                      ),
                // content / isi page / screen
                Expanded(
                  child: Container(
                    padding: !context.isPhone
                        ? const EdgeInsets.all(50)
                        : const EdgeInsets.all(20),
                    margin: !context.isPhone
                        ? const EdgeInsets.all(10)
                        : const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: !context.isPhone
                          ? BorderRadius.circular(50)
                          : BorderRadius.circular(30),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: authC.streamTraining(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              heightFactor: 100,
                              widthFactor: 100,
                              child: CircularProgressIndicator());
                        }

                        return ListView(
                          clipBehavior: Clip.antiAlias,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(5),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;

                            return GestureDetector(
                              onTap: () => Get.toNamed(
                                  '/training-peserta/${data['jenis']}'),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['jenis'],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          data['keterangan'],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          data['tanggal_sertifikat'],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).backgroundColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            data['jumlah_peserta'].toString(),
                                            style:
                                                const TextStyle(fontSize: 30),
                                          ),
                                          const Text(
                                            'Peserta',
                                            style: TextStyle(
                                                fontSize: 10, height: 1),
                                          )
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton(
                                      elevation: 3.2,
                                      onSelected: (String value) {
                                        if (value == edit) {
                                          authC.jenisTrainingController.text =
                                              data['jenis'];
                                          authC.tanggalSertifikatController
                                                  .text =
                                              data['tanggal_sertifikat'];
                                          authC.keteranganController.text =
                                              data['keterangan'];
                                          addTraining(
                                              context: context,
                                              type: 'Update',
                                              docId: data['jenis']);
                                        } else {}
                                      },
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem(
                                            value: edit, child: Text(edit)),
                                        PopupMenuItem(
                                            value: delete, child: Text(delete)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    // Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // const Text(
                    //       //   'People You May Know',
                    //       //   style: TextStyle(
                    //       //     color: AppColors.primaryText,
                    //       //     fontSize: 30,
                    //       //   ),
                    //       // ),
                    //       // const SizedBox(
                    //       //   height: 20,
                    //       // ),
                    //       // SizedBox(height: 200, child: PeopleYouMayKnow()),
                    //     ]),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            addTraining(context: context, type: 'Add');
          },
          label: const Text('Add training'),
          icon: const Icon(Ionicons.add_outline)),
    );
  }
}
