import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/auth/screens/login_screen.dart';

import '../../../model/user_model.dart';
import '../../../utils/LocalStorage.dart';
import '../../../utils/SingleTon.dart';
import 'authentication.dart';

class CloudFireStore extends GetxController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var allMembers = 0.obs;
  var loading = false.obs;

  static final CollectionReference _server =
      FirebaseFirestore.instance.collection("serverurl");
  static final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");
  static Future<bool> addServerURl({required String url}) async {
    var result = false;
    try {
      await _server.doc('url').set({
        "serverUrl": url,
      });
      result = true;
      Get.back();
      Authentication.snackBarSuccess(
          title: "Successfully", message: 'ServerUrl has been setted.');
      log("result url ----- > $result");
    } catch (e) {
      print("error in get User :$e");

      Authentication.snackBarError("Something went wrong");
    }
    return result;
  }

  Future<bool> addUserInformation({
    required String docId,
    required UserModel userInfo,
  }) async {
    var success = false;
    try {
      await _users.doc(docId).set({
        "email": userInfo.email,
        "id": userInfo.id,
        "name": userInfo.name,
        "phone": userInfo.phone,
        "isAdmin": userInfo.isAdmin,
        "active": userInfo.isActive,
        "photo": userInfo.photo,
        "provide": userInfo.provide,
      }).then((val) {
        success = true;
        debugPrint("SUCCESS");
      });
    } on FirebaseException catch (error) {
      debugPrint(
        'CatchError in addDataToFireStore this is error : >> $error',
      );
    } catch (error) {
      debugPrint(
        'CatchError in addDataToFireStore this is error : >> $error',
      );
    }
    return success;
  }

  static Future<String> getServerURl() async {
    var result = '';
    try {
      await _server.doc('url').get().then((value) {
        result = value['serverUrl'];
      });
      log("result url ----- > $result");
    } catch (e) {
      print("error in get User :$e");

      Authentication.snackBarError("Something went wrong");
    }
    return result;
  }

  static late UserModel _data;
  static Future<UserModel> getUser({
    required String docId,
  }) async {
    try {
      await _users.doc(docId).get().then((value) {
        if (value.exists) {
          _data = UserModel.fromJson(value.data() as Map<String, dynamic>);
        } else {
          _data = UserModel();
        }
      });
    } catch (e) {
      print("error in get User :$e");
      Get.back();
      Authentication.snackBarError("Something went wrong");
      LocalStorage.clearData();
      await Authentication().signOut();
      Get.to(LoginScreen());
    }
    return _data;
  }

  static Future<List<UserModel>> getAllUser() async {
    var data = <UserModel>[];
    try {
      await _users.get().then((value) {
        for (var item in value.docs) {
          var temp = UserModel.fromJson(item.data() as Map<String, dynamic>);
          if (temp.id != GlobalClass().user.value.id) data.add(temp);
        }
      });
    } catch (e) {
      print("error in get User :$e");
      Get.back();
      Authentication.snackBarError("Something went wrong");
      LocalStorage.clearData();
      await Authentication().signOut();
      Get.to(LoginScreen());
    }
    return data;
  }

  Future<void> removeUser({
    required String docId,
  }) async {
    try {
      await _firebaseFirestore.collection("users").doc(docId).delete().then(
        (value) async {
          debugPrint("success update");
        },
      );
    } catch (error) {
      debugPrint(
        'CatchError in getDataByID this is error : >> $error',
      );
    }
  }

  Future<void> updateUser({
    required String docId,
    required Map<Object, Object> data,
  }) async {
    try {
      await _firebaseFirestore.collection("users").doc(docId).update(data).then(
        (value) async {
          debugPrint("success update");
          await CloudFireStore.getUser(
            docId: docId,
          ).then((value) {
            if (value.id != null) {
              GlobalClass().user.value = value;
            }
          });
        },
      );
    } catch (error) {
      debugPrint(
        'CatchError in getDataByID this is error : >> $error',
      );
    }
  }
}
