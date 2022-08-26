import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/training_peserta_controller.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../utils/style/AppColors.dart';
import '../../../utils/widget/header.dart';
import '../../../utils/widget/sideBar.dart';

class TrainingPesertaView extends GetView<TrainingPesertaController> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final authC = Get.find<AuthController>();
  var id = Get.parameters['id'];
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
                        child: Column(
                          children: [
                            Row(
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
                            const SizedBox(
                              height: 10,
                            ),
                            context.isPhone
                                ? Obx(
                                    () => authC.isShow.isTrue
                                        ? TextField(
                                            onChanged: (value) =>
                                                authC.searchAddKaryawan(value),
                                            controller: authC
                                                .searchAddKaryawanController,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 40, right: 10),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.search,
                                                color: Colors.black,
                                              ),
                                              hintText: 'Search add karyawan',
                                            ),
                                          )
                                        : const SizedBox(),
                                  )
                                : const SizedBox(),
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
                    child: Obx(
                      () => authC.hasilPencarian.isEmpty
                          ? StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                              stream: authC.streamTrainingDetail(id!),
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
                                var userEmail = (snapshot.data!.data()
                                        as Map<String, dynamic>)["list_peserta"]
                                    as List;
                                return ListView.builder(
                                  itemCount: userEmail.length,
                                  clipBehavior: Clip.antiAlias,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    // stream untuk mengambil data task nya
                                    return StreamBuilder<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>(
                                        stream:
                                            authC.streamUser(userEmail[index]),
                                        builder: (context, snapshot2) {
                                          if (snapshot2.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                heightFactor: 100,
                                                widthFactor: 100,
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          // data untuk task
                                          var data = snapshot2.data!.data();
                                          // data user image yang akan stream lagi
                                          // var dataUser = (snapshot2.data!.data()
                                          //     as Map<String, dynamic>)["asign_to"] as List;

                                          return GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 90,
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: AppColors.cardBg,
                                              ),
                                              margin: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          data!['photo']),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data['nip'],
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          maxLines: 1,
                                                        ),
                                                        // s
                                                        Text(
                                                          data['name'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                          maxLines: 5,
                                                        ),
                                                        Text(
                                                          data['jabatan'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                          maxLines: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                );
                              })
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              shrinkWrap: true,
                              itemCount: authC.hasilPencarian.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () => authC.addPesertaTraining(
                                    id!, authC.hasilPencarian[index]['email']),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    image: NetworkImage(
                                        authC.hasilPencarian[index]['photo']),
                                  ),
                                ),
                                title: Text(authC.hasilPencarian[index]['nip']),
                                subtitle:
                                    Text(authC.hasilPencarian[index]['name']),
                                trailing: const Icon(Ionicons.add),
                              ),
                            ),
                    ),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            authC.isShow.value = true;
            // addTraining(context: context, type: 'Add');
          },
          label: const Text('Add karyawan'),
          icon: const Icon(Ionicons.add_outline)),
    );
  }
}
