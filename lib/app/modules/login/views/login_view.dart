import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../data/controller/auth_controller.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Container(
          margin: context.isPhone
              ? EdgeInsets.all(Get.width * 0.1)
              : EdgeInsets.all(Get.height * 0.1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Row(children: [
            // biru
            !context.isPhone
                ? Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                        color: Colors.blue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Welcome',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 70,
                                ),
                              ),
                              Text(
                                'To',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                ),
                              ),
                              Text(
                                'Politeknik Takumi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                'ENTRUST THE FUTURE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  )
                : const SizedBox(),
            // putih
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      context.isPhone
                          ? Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                  Text(
                                    'Welcome',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 40,
                                    ),
                                  ),
                                  Text(
                                    'To',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    'Politeknik Takumi',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'ENTRUST THE FUTURE',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ])
                          : const SizedBox(),
                      Image.asset(
                        'assets/icons/icon.png',
                        height: Get.height * 0.2,
                        width: Get.height * 0.2,
                        fit: BoxFit.contain,
                      ),
                      FloatingActionButton.extended(
                        onPressed: () => authC.signInWithGoogle(),
                        label: const Text('Sign In With Google'),
                        icon: const Icon(Ionicons.logo_google,
                            color: Colors.white),
                      )
                    ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
