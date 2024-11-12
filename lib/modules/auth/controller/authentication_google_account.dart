import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/utils/Utilty.dart';
import 'authentication.dart';

class GoogleSignInProvider {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user {
    return _user!;
  }

  Future<bool> googleLogin() async {
    var authCon = Get.put(AuthController());
    var success = false;
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Get.back();
        return success;
      } else {
        _user = googleUser;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final login =
          await Authentication().signInWithCredential(credential: credential);
      await authCon.loginSuccess(login, account: googleUser);
      success = true;
    } catch (e) {
      Get.back();
      log(e.toString());
      alertDialog(
        desc: 'Unexpected error while logging in.\n Please try again later!',
      );
    }
    if (success) {
      Get.back();
    }
    return success;
  }
}
