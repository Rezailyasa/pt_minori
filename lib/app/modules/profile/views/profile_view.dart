import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pt_minori/app/utils/widget/editUser.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../utils/style/AppColors.dart';
import '../../../utils/widget/header.dart';
import '../../../utils/widget/profileW.dart';
import '../../../utils/widget/sideBar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final authConn = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    authConn.getUser();
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
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                  title: 'Sign Out',
                                  content: const Text(
                                      'Are you sure want to sign out?'),
                                  cancel: ElevatedButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancle'),
                                  ),
                                  confirm: ElevatedButton(
                                    onPressed: () => authConn.logout(),
                                    child: const Text('Sign Out'),
                                  ),
                                );
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    'Sign Out',
                                    style: TextStyle(
                                        color: AppColors.primaryText,
                                        fontSize: 16),
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
                    child: ProfileW(),
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
            editUser(context: context);
          },
          label: const Text('Edit'),
          icon: const Icon(Ionicons.pencil_outline)),
    );
  }
}
