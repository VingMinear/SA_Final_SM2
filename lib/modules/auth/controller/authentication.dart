import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/utils/Utilty.dart';

import '../../../model/user_model.dart';
import 'cloud_fire_store.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  static snackBarError(String message) {
    Get.snackbar(
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
      "Ops Sorry",
      message,
    );
  }

  static snackBarSuccess({required String title, required String message}) {
    Get.snackbar(
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
      title,
      message,
    );
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser!.providerData.asMap().entries.map((e) {
        debugPrint("Value use : ${e.value}");
      }).toList();
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError when signInWithEmailAndPassword this is error : >> ${error.message!.trim()}',
      );
      checkError(error);
      snackBarError(error.code);
      return false;
    }
  }

  checkError(FirebaseAuthException error) {
    Get.back();
    switch (error.code) {
      // case 'user-not-found':
      case 'invalid-email':
        alertDialog(desc: error.message!);
        break;
      case 'requires-recent-login':
        alertDialog(
          desc: error.message!,
          barrierDismissible: false,
          onCf: () {
            logOut();
          },
        );
        break;
      case "user-not-found":
        alertDialog(desc: "Your email dose not exist. Please try again!");
        break;

      default:
        alertDialog(desc: "Your email and password dose not match!");
        break;
    }
  }

  Future<bool> createUserWithEmailAndPassword({
    required String userName,
    required String email,
    required String password,
    required bool userTypeAdmin,
    required String ph,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userInfo = AuthController.getUserInforAfterLogin();
      await CloudFireStore().addUserInformation(
        docId: currentUser!.uid,
        userInfo: UserModel(
          email: userInfo.email,
          id: userInfo.id,
          name: userName,
          phone: ph,
          isAdmin: userTypeAdmin,
          photo: userInfo.photo,
          provide: 'email',
        ),
      );
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError when createUserWithEmailAndPassword this is error : >> $error',
      );
      Get.back();
      alertDialog(desc: error.message!);
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError in signOut this is error : >> $error',
      );
    }
  }

  Future<bool> updateEmial({required String email}) async {
    try {
      var firebaseuser = _firebaseAuth.currentUser;
      await firebaseuser!.updateEmail(email);
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError when signInWithCredential this is error : >> $error',
      );
      Get.back();
      switch (error.code) {
        case 'requires-recent-login':
          alertDialog(
            desc: error.message!,
            barrierDismissible: false,
            onCf: () {
              logOut();
            },
          );
          break;
        default:
          alertDialog(desc: error.message!);
          break;
      }
      return false;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError when signInWithCredential this is error : >> $error',
      );

      return false;
    }
  }

  Future<bool> signInWithCredential({
    required AuthCredential credential,
  }) async {
    try {
      await _firebaseAuth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'CatchError when signInWithCredential this is error : >> $error',
      );
      snackBarError(error.code);
      return false;
    }
  }
}
