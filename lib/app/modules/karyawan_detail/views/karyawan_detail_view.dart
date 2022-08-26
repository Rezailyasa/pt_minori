import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../data/controller/auth_controller.dart';
import '../../../utils/style/AppColors.dart';
import '../../../utils/widget/header.dart';
import '../../../utils/widget/sideBar.dart';
import '../controllers/karyawan_detail_controller.dart';

class KaryawanDetailView extends GetView<KaryawanDetailController> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final authC = Get.find<AuthController>();
  var email = Get.parameters['email'];

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
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: authC.streamUser(email!),
                      builder: (context, snapshot) {
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
                        var dataUser = snapshot.data!.data();
                        var listTraining = (snapshot.data!.data()
                            as Map<String, dynamic>)["list_training"] as List;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 90,
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.cardBg,
                                ),
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image(
                                        image: NetworkImage(dataUser!['photo']),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dataUser['nip'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                          ),
                                          // s
                                          Text(
                                            dataUser['name'],
                                            style:
                                                const TextStyle(fontSize: 16),
                                            maxLines: 5,
                                          ),
                                          Text(
                                            dataUser['jabatan'],
                                            style:
                                                const TextStyle(fontSize: 16),
                                            maxLines: 5,
                                          ),
                                        ],
                                      ),
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
                                            listTraining.length.toString(),
                                            style:
                                                const TextStyle(fontSize: 30),
                                          ),
                                          const Text(
                                            'Training',
                                            style: TextStyle(
                                                fontSize: 10, height: 1),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: listTraining.length,
                              clipBehavior: Clip.antiAlias,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                // stream untuk mengambil data task nya
                                return StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: authC.streamTrainingDetail(
                                        listTraining[index]),
                                    builder: (context, snapshot2) {
                                      if (snapshot2.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            heightFactor: 100,
                                            widthFactor: 100,
                                            child: CircularProgressIndicator());
                                      }
                                      // data untuk task
                                      var dataTraining = snapshot2.data!.data();
                                      // data user image yang akan stream lagi
                                      // var dataUser = (snapshot2.data!.data()
                                      //     as Map<String, dynamic>)["asign_to"] as List;

                                      return Container(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'No',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        height: 1),
                                                  ),
                                                  Text(
                                                    '${index + 1}',
                                                    style: const TextStyle(
                                                        fontSize: 30),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(dataTraining!['jenis']),
                                                Text(
                                                    dataTraining['keterangan']),
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(dataTraining[
                                                'tanggal_sertifikat']),
                                          ],
                                        ),
                                      );
                                    });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
