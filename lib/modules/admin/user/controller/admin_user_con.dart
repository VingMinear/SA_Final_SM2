import 'dart:developer';

import 'package:get/get.dart';
import 'package:homework3/model/user_model.dart';
import 'package:homework3/modules/auth/controller/cloud_fire_store.dart';

class AdminUserCon extends GetxController {
  var listUser = <UserModel>[].obs;
  var backuplist = <UserModel>[];
  var loading = false.obs;
  Future<void> removeUser({required String docId}) async {
    try {
      await CloudFireStore().removeUser(docId: docId);
    } catch (error) {
      log(
        'CatchError while removeUser ( error message ) : >> $error',
      );
    }
  }

  Future<void> searchUser({required String text}) async {
    if (text.isEmpty) {
      fetchCustomer();
    } else {
      loading(true);
      await Future.delayed(
        const Duration(milliseconds: 200),
        () {},
      );
      var temp = backuplist
          .where((p0) =>
              p0.name!.toLowerCase().contains(text.toLowerCase()) ||
              p0.phone!.toLowerCase().contains(text.toLowerCase()) ||
              p0.email!.toLowerCase().contains(text.toLowerCase()))
          .toList();
      listUser.value = temp.toList();
      loading(false);
    }
  }

  Future<void> enableUser({required String docId, required bool enable}) async {
    try {
      await CloudFireStore().updateUser(docId: docId, data: {
        "active": enable,
      });
    } catch (error) {
      log(
        'CatchError while enableUser ( error message ) : >> $error',
      );
    }
  }

  Future<List<UserModel>> fetchCustomer() async {
    loading(true);
    await Future.delayed(
      const Duration(milliseconds: 300),
      () {},
    );
    await CloudFireStore.getAllUser().then((value) {
      listUser.value = value.toList();
      backuplist = value.toList();
    });
    loading(false);
    return listUser;
  }
}
