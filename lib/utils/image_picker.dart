import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../modules/auth/controller/auth_controller.dart';
import '../modules/auth/controller/cloud_fire_store.dart';

class ImagePickerProvider extends GetxController {
  static init() => Get.put(ImagePickerProvider());
  static final ref = FirebaseStorage.instance.ref();
  var loadingUpdageImage = false.obs;
  var imageUrl = "".obs;

  removePhoto() async {
    var docId = AuthController.userInformation;
    imageUrl("");
    CloudFireStore().updateUser(
      docId: docId!.id!,
      data: {
        "photo": imageUrl.value,
      },
    );
  }

  Future<void> deletedAllPhoto(String name) async {
    try {
      var data = await ref.child('images').list();
      data.items.map((e) {
        // if (name != e.name) {
        //   e.delete();
        // }
      }).toList();
    } on FirebaseException catch (error) {
      debugPrint(
        'CatchError in deleled this is error : >> $error',
      );
    } catch (error) {
      debugPrint(
        'CatchError in deleled this is error : >> $error',
      );
    }
  }

  Future<String> uploadPhoto(
      {required String path, required String userId}) async {
    loadingDialog();
    try {
      final data = ref.child('images').child(userId);
      final result = await data.putFile(File(path));
      final fileUrl = await result.ref.getDownloadURL();
      imageUrl.value = fileUrl;

      await CloudFireStore().updateUser(
        docId: userId,
        data: {
          "photo": imageUrl.value,
        },
      );
    } on FirebaseException catch (error) {
      debugPrint(
        'CatchError in updateData this is error : >> $error',
      );
    } catch (error) {
      debugPrint(
        'CatchError in updateData this is error : >> $error',
      );
    }
    Get.back();
    return imageUrl.value;
  }

  final userInfor = AuthController.getUserInforAfterLogin();
  Future<String> pickImage(
      {required ImageSource source,
      required bool updateProfile,
      required String userId}) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
      );
      if (image == null) return "";
      var filePath = (await compressImage(image.path));
      imageUrl.value = filePath.path;
      if (updateProfile) {
        await uploadPhoto(
          userId: userId,
          path: filePath.path,
        );
      }
    } on PlatformException catch (error) {
      debugPrint(
        'CatchError when pickImage this is error : >> $error',
      );
    }
    return imageUrl.value;
  }

  Future<XFile> compressImage(String path) async {
    final newPath =
        p.join((await getTemporaryDirectory()).path, '${DateTime.now()}.jpg');
    final result = await FlutterImageCompress.compressAndGetFile(path, newPath);
    return result!;
  }
}
