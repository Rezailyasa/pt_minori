import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../utils/style/AppColors.dart';
import '../../../utils/widget/header.dart';
import '../../../utils/widget/sideBar.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final authC = Get.find<AuthController>();
  // var id = Get.parameters['id'];
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
                                ? TextField(
                                    onChanged: (value) =>
                                        authC.searchKaryawan(value),
                                    controller: authC.searchKaryawanController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.only(
                                          left: 40, right: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                            color: Colors.blue),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Search karyawan',
                                    ),
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
                      () => authC.hasilPencarian2.isEmpty
                          ? StreamBuilder<QuerySnapshot>(
                              stream: authC.streamUsers(),
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

                                return ListView(
                                    clipBehavior: Clip.antiAlias,
                                    padding: const EdgeInsets.all(5),
                                    shrinkWrap: true,
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
                                      var list = data['list_training'] as List;
                                      // stream untuk mengambil data task nya
                                      return GestureDetector(
                                        onTap: () => Get.toNamed(
                                            '/karyawan-detail/${data['email']}'),
                                        child: Container(
                                          margin: const EdgeInsets.all(8),
                                          height: 90,
                                          decoration: BoxDecoration(
                                              color: AppColors.cardBg,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image(
                                                  image: NetworkImage(
                                                      data['photo']),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['nip'],
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    data['name'],
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    data['jabatan'],
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  // SizedBox(height: 10),
                                                  // Text(
                                                  //   data['tanggal_sertifikat'],
                                                  //   style: const TextStyle(
                                                  //       fontSize: 12),
                                                  // ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      list.length.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 30),
                                                    ),
                                                    const Text(
                                                      'Training',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          height: 1),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList());
                              })
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              shrinkWrap: true,
                              itemCount: authC.hasilPencarian2.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {
                                  Get.toNamed(
                                      '/karyawan-detail/${authC.hasilPencarian2[index]['email']}');
                                },
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    image: NetworkImage(
                                        authC.hasilPencarian2[index]['photo']),
                                  ),
                                ),
                                title:
                                    Text(authC.hasilPencarian2[index]['nip']),
                                subtitle:
                                    Text(authC.hasilPencarian2[index]['name']),
                                trailing: const Icon(Ionicons.chevron_forward),
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
    );
  }
}
