import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homework3/modules/auth/screens/success_screen.dart';
import 'package:homework3/modules/bottom_navigation_bar/bottom_navigatin_bar.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/Utilty.dart';

import '../../../model/user_model.dart';
import '../../../utils/LocalStorage.dart';
import '../../../utils/image_picker.dart';
import '../../admin/dashboard/screen/dashboard_screen.dart';
import 'authentication.dart';
import 'cloud_fire_store.dart';

class AuthController extends GetxController {
  Future<void> login({
    required String name,
    required String pwd,
  }) async {
    bool login = await Authentication().signInWithEmailAndPassword(
      email: name,
      password: pwd,
    );

    await loginSuccess(login);
  }

  var txtEmail = TextEditingController();
  var txtPass = TextEditingController();
  void onClear() {
    txtEmail.text = "";
    txtPass.text = "";
  }

  final imageCon = Get.put(ImagePickerProvider());
  static UserModel? userInformation = UserModel();
  updatePhoto() {
    imageCon.imageUrl(userInformation!.photo);
  }

  Future<void> register({
    required String userName,
    required String email,
    required String password,
    required String ph,
    required String userType,
    required bool isAdmin,
  }) async {
    try {
      bool isTypeAdmin = false;
      if (userType.isNotEmpty && isAdmin) {
        if (userType.toLowerCase() == "admin") {
          isTypeAdmin = true;
        }
      }
      await Authentication()
          .createUserWithEmailAndPassword(
        userName: userName,
        email: email,
        userTypeAdmin: isTypeAdmin,
        password: password,
        ph: ph,
      )
          .then((value) {
        if (value) {
          Get.back();
          Future.delayed(
            const Duration(milliseconds: 250),
            () {
              if (isAdmin) {
                showTaost("Account has been created successfully 🎉✅");
                Get.back();
              } else {
                Get.off(SuccessScreen(
                  desc:
                      '''Your account has been successfully created, and we're excited to have you join our platform.\nThank you for choosing us, and we look forward to serving you!''',
                ));
              }
            },
          );
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when register this is error : >> $error',
      );
    }
  }

  Future<void> loginSuccess(bool login, {GoogleSignInAccount? account}) async {
    if (login) {
      var user_id = Authentication().currentUser?.uid;

      Authentication obj = Authentication();
      var uid = obj.currentUser?.uid;
      log("Uid $uid");
      await CloudFireStore.getUser(docId: obj.currentUser!.uid)
          .then((value) async {
        if (value.id == null) {
          log("User ${account}");
          if (account != null) {
            await CloudFireStore().addUserInformation(
              docId: account.id,
              userInfo: UserModel(
                email: account.email,
                id: account.id,
                name: account.displayName,
                photo: account.photoUrl!,
                provide: 'google',
              ),
            );
            await CloudFireStore.getUser(docId: account.id).then((value) {
              GlobalClass().user(value);
            });
          }
        } else {
          GlobalClass().user.value = value;
        }
      });
      if (GlobalClass().user.value.isActive) {
        LocalStorage.storeData(
          key: "user_id",
          value: user_id,
        );

        updatePhoto();
        onClear();
        Get.back();
        Future.delayed(
          const Duration(milliseconds: 250),
          () async {
            if (GlobalClass().user.value.isAdmin) {
              await FirebaseMessaging.instance.subscribeToTopic('order');
              Get.offAll(() => DashboardScreen());
            } else {
              Get.offAll(BottomNavigationBarScreen());
            }
          },
        );
      } else {
        Get.back();
        await alertDialog(
          desc: "Your account has been lock! Please contact to admin",
        );
      }
    } else {
      debugPrint("cannot login");
    }
  }

  static UserModel getUserInforAfterLogin() {
    Authentication obj = Authentication();
    return UserModel(
      email: obj.currentUser?.email ?? "",
      id: obj.currentUser?.uid ?? "",
      name: obj.currentUser?.displayName ?? "",
      photo: obj.currentUser?.photoURL ?? "",
      provide: "- -",
    );
  }
}
