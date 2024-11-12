import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/utils/LocalStorage.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/PhotoViewDetail.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/SingleTon.dart';
import '../../../utils/image_picker.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var user = GlobalClass().user;
    log("Pho ${user.value.photo}");
    return Obx(
      () => IntrinsicHeight(
        child: Row(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Get.to(
                  PhotoViewDetail(
                    imageUrl: user.value.photo,
                  ),
                );
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: CustomCachedNetworkImage(
                  imgUrl: user.value.photo,
                ),
              ),
            ),
            const VerticalDivider(
              color: Colors.grey,
              width: 30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.value.name ?? 'Unkown',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    user.value.email ?? "SS5@example.com",
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.value.phone ?? "",
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: const Color(0xFFEEEEEE),
              height: 1,
              padding: const EdgeInsets.symmetric(horizontal: 24),
            )
          ],
        ),
      ),
    );
  }
}

Widget cupertinoModal(BuildContext context) {
  var user = GlobalClass().user.value;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_cupertino.length, (index) {
        return ListTile(
          onTap: () async {
            Get.back();
            var userId = LocalStorage.getStringData(key: 'user_id');
            switch (index) {
              case 0:
                Get.to(
                  PhotoViewDetail(imageUrl: user.photo),
                );
                break;
              default:
                await ImagePickerProvider().pickImage(
                  source: index == 1 ? ImageSource.gallery : ImageSource.camera,
                  updateProfile: true,
                  userId: userId,
                );
                break;
            }
          },
          title: Text(_cupertino[index].title!),
          leading: _cupertino[index].icon,
        );
      }),
    ),
  );
}

List<CupertinoItem> _cupertino = [
  CupertinoItem(
    title: 'View Photo',
    icon: const Icon(CupertinoIcons.photo),
  ),
  CupertinoItem(
    title: 'Upload Photo',
    icon: const Icon(CupertinoIcons.cloud_upload),
  ),
  CupertinoItem(
    title: 'Camera',
    icon: const Icon(CupertinoIcons.camera),
  ),
];

class CupertinoItem {
  String? title;
  Icon? icon;

  CupertinoItem({
    this.title,
    this.icon,
  });
}
