import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? _userCredential;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController searchAddKaryawanController,
      searchKaryawanController,
      displayNameController,
      jabatanController,
      jenisTrainingController,
      tanggalSertifikatController,
      keteranganController,
      nipController,
      dueDateController;

  @override
  void onInit() {
    super.onInit();
    searchAddKaryawanController = TextEditingController();
    searchKaryawanController = TextEditingController();
    displayNameController = TextEditingController();
    jabatanController = TextEditingController();
    jenisTrainingController = TextEditingController();
    tanggalSertifikatController = TextEditingController();
    keteranganController = TextEditingController();
    nipController = TextEditingController();
    dueDateController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchAddKaryawanController.dispose();
    searchKaryawanController.dispose();
    displayNameController.dispose();
    jabatanController.dispose();
    jenisTrainingController.dispose();
    tanggalSertifikatController.dispose();
    keteranganController.dispose();
    nipController.dispose();
    dueDateController.dispose();
  }

  void clearEditingControllers() {
    searchAddKaryawanController.clear();
    searchKaryawanController.clear();
    displayNameController.clear();
    jabatanController.clear();
    jenisTrainingController.clear();
    tanggalSertifikatController.clear();
    keteranganController.clear();
    nipController.clear();
    dueDateController.clear();
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await auth
        .signInWithCredential(credential)
        .then((value) => _userCredential = value);
    print(googleUser!.email);
    // Once signed in, return the UserCredential
    // firebase
    CollectionReference users = firestore.collection('users');

    final cekUsers = await users.doc(googleUser.email).get();
    if (!cekUsers.exists) {
      users.doc(googleUser.email).set({
        'uid': _userCredential!.user!.uid,
        'nip': '',
        'list_training': [],
        'name': googleUser.displayName,
        'email': googleUser.email,
        'photo': googleUser.photoUrl,
        'jabatan': 'Peserta',
        'createdAt': _userCredential!.user!.metadata.creationTime.toString(),
        'lastLoginAt':
            _userCredential!.user!.metadata.lastSignInTime.toString(),
        // 'list_cari': [R,RE,REZ,REZA]
      }).then((value) async {
        String temp = '';
        try {
          for (var i = 0; i < googleUser.displayName!.length; i++) {
            temp = temp + googleUser.displayName![i];
            await users.doc(googleUser.email).set({
              'list_cari': FieldValue.arrayUnion([temp.toUpperCase()])
            }, SetOptions(merge: true));
          }
        } catch (e) {
          print(e);
        }
      });
    } else {
      users.doc(googleUser.email).update({
        'lastLoginAt':
            _userCredential!.user!.metadata.lastSignInTime.toString(),
      });
    }

    Get.offAllNamed(Routes.HOME);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  var isShow = false.obs;
  var kataCari = [].obs;
  var hasilPencarian = [].obs;
  void searchAddKaryawan(String keyword) async {
    CollectionReference users = firestore.collection('users');

    if (keyword.isNotEmpty) {
      final hasilQuery = await users
          .where('list_cari', arrayContains: keyword.toUpperCase())
          .get();

      if (hasilQuery.docs.isNotEmpty) {
        for (var i = 0; i < hasilQuery.docs.length; i++) {
          kataCari.add(hasilQuery.docs[i].data() as Map<String, dynamic>);
        }
      }

      if (kataCari.isNotEmpty) {
        hasilPencarian.value = [];
        kataCari.forEach((element) {
          print(element);
          hasilPencarian.add(element);
        });
        kataCari.clear();
      }
    } else {
      kataCari.value = [];
      hasilPencarian.value = [];
    }
    kataCari.refresh();
    hasilPencarian.refresh();
  }

  var kataCari2 = [].obs;
  var hasilPencarian2 = [].obs;
  void searchKaryawan(String keyword) async {
    CollectionReference users = firestore.collection('users');

    if (keyword.isNotEmpty) {
      final hasilQuery = await users
          .where('list_cari', arrayContains: keyword.toUpperCase())
          .get();

      if (hasilQuery.docs.isNotEmpty) {
        for (var i = 0; i < hasilQuery.docs.length; i++) {
          kataCari2.add(hasilQuery.docs[i].data() as Map<String, dynamic>);
        }
      }

      if (kataCari2.isNotEmpty) {
        hasilPencarian2.value = [];
        kataCari2.forEach((element) {
          print(element);
          hasilPencarian2.add(element);
        });
        kataCari2.clear();
      }
    } else {
      kataCari2.value = [];
      hasilPencarian2.value = [];
    }
    kataCari2.refresh();
    hasilPencarian2.refresh();
  }

  void addPesertaTraining(String idTraining, String emailFriends) async {
    CollectionReference usersColl = firestore.collection('users');
    CollectionReference trainingColl = firestore.collection('training');

    var total;

    //cek data ada atau tidak

    await trainingColl.doc(idTraining).set({
      'list_peserta': FieldValue.arrayUnion([emailFriends]),
    }, SetOptions(merge: true)).whenComplete(() async {
      await usersColl.doc(emailFriends).set({
        'list_training': FieldValue.arrayUnion([idTraining]),
      }, SetOptions(merge: true)).whenComplete(() async {
        await trainingColl.doc(idTraining).get().then((value) {
          var t = value.data() as Map<String, dynamic>;
          var list = t['list_peserta'] as List;
          total = list.length;
        }).then((value) async {
          await trainingColl.doc(idTraining).update({
            'jumlah_peserta': total,
          });
        });
        isShow.value = false;
        Get.snackbar("User", "User sucsessfuly added");
      }).catchError((error) {
        Get.snackbar("User", "User Error added");
      });
    });

    kataCari.clear();
    hasilPencarian.clear();
    searchAddKaryawanController.clear();
    searchKaryawanController.clear();
    Get.back();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamFriends() {
    return firestore
        .collection('friends')
        .doc(auth.currentUser!.email)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUsers() {
    return firestore.collection('users').snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPeople() async {
    CollectionReference friendsCollec = firestore.collection('friends');

    final cekFriends = await friendsCollec.doc(auth.currentUser!.email).get();
    var listFriends =
        (cekFriends.data() as Map<String, dynamic>)['emailFriends'] as List;
    QuerySnapshot<Map<String, dynamic>> hasil = await firestore
        .collection('users')
        .where('email', whereNotIn: listFriends)
        .get();

    return hasil;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTask(String taskId) {
    return firestore.collection('task').doc(taskId).snapshots();
  }

  void saveBiodata(String nip, String name, String jabatan) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    CollectionReference usersColl = firestore.collection('users');
    await usersColl.doc(auth.currentUser!.email).update({
      'nip': nip,
      'name': name,
      'jabatan': jabatan,
    }).whenComplete(() async {
      Get.back();
      Get.snackbar('Profile', 'Sucsesfuly updated');
    }).catchError((error) {
      Get.snackbar('Profile', 'Error updated');
    });
  }

  var jabatan = ''.obs;
  var nip = ''.obs;
  void getUser() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.email)
        .get()
        .then((value) {
      var hasil = value.data();
      jabatan.value = hasil!['jabatan'];
      nip.value = hasil['nip'];
      jabatanController.text = hasil['jabatan'];
    });
  }

  void saveTraining(String type, String jenisTraining, String tglSertifikat,
      String keterangan) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final rubah = DateFormat('yyyy-MM-dd').parse(tglSertifikat);
    final tglS = DateFormat('dd-MM-yyyy').format(rubah);

    formKey.currentState!.save();
    CollectionReference usersColl = firestore.collection('training');

    if (type == 'Add') {
      await usersColl.doc(jenisTraining).set({
        'jenis': jenisTraining,
        'tanggal_sertifikat': tglS,
        'status': 'Aktif',
        'keterangan': keterangan,
        'list_peserta': [],
        'jumlah_peserta': 0
      }).whenComplete(() async {
        clearEditingControllers();
        Get.back();
        Get.snackbar('Sertifikat', 'Sucsesfuly added');
      }).catchError((error) {
        Get.snackbar('Sertifikat', 'Error added');
      });
    } else {
      await usersColl.doc(jenisTraining).update({
        'jenis': jenisTraining,
        'tanggal_sertifikat': tglS,
        'keterangan': keterangan,
      }).whenComplete(() async {
        clearEditingControllers();
        Get.back();
        Get.snackbar('Sertifikat', 'Sucsesfuly added');
      }).catchError((error) {
        Get.snackbar('Sertifikat', 'Error added');
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamTraining() {
    return firestore
        .collection('training')
        .where('status', isEqualTo: 'Aktif')
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTrainingDetail(
      String id) {
    return firestore.collection('training').doc(id).snapshots();
  }
}
