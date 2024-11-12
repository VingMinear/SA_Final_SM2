import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/user_model.dart';
import '../../../utils/SingleTon.dart';
import '../../../utils/Utilty.dart';
import '../../../widgets/CustomCachedNetworkImage.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/primary_button.dart';
import '../../auth/controller/authentication.dart';
import '../../auth/controller/cloud_fire_store.dart';
import '../components/header.dart';
import 'add_address_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var nameCon = TextEditingController();
  var emailCon = TextEditingController();
  var phCon = TextEditingController();
  var user = GlobalClass().user;
  @override
  void initState() {
    nameCon.text = user.value.name ?? '';
    emailCon.text = user.value.email ?? '';
    phCon.text = user.value.phone ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Edit Profile',
        showNotification: false,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  FadeIn(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: cupertinoModal,
                        );
                      },
                      child: Container(
                        width: 110,
                        height: 110,
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
                  ),
                  const SizedBox(height: 10),
                  const Text("Tap to update your profile here.")
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  buildField(
                    title: 'Name :',
                    hintText: 'Name',
                    required: false,
                    controller: nameCon,
                  ),
                  buildField(
                    delay: 50,
                    title: 'Email :',
                    hintText: 'Email',
                    required: false,
                    controller: emailCon,
                  ),
                  buildField(
                    delay: 100,
                    title: 'Phone number:',
                    hintText: 'Phone number',
                    required: false,
                    controller: phCon,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomPrimaryButton(
              textValue: 'Update',
              textColor: Colors.white,
              onPressed: () async {
                var name = nameCon.text.trim();
                var phone = phCon.text.trim();
                var email = emailCon.text.trim();
                if (name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty) {
                  await updateProfile(email, name, phone);
                } else {
                  alertDialog(desc: 'Please input all fields !');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile(String email, String name, String phone) async {
    loadingDialog();
    UserModel userInfo = GlobalClass().user.value;
    await Authentication().updateEmial(email: email).then((v) async {
      if (v) {
        await CloudFireStore()
            .addUserInformation(
          docId: userInfo.id!,
          userInfo: UserModel(
            email: email,
            id: userInfo.id,
            name: name,
            phone: phone,
            photo: userInfo.photo,
            provide: 'email',
          ),
        )
            .then((value) async {
          await CloudFireStore.getUser(docId: userInfo.id!).then((value) {
            GlobalClass().user(value);
          });
          Get.back();
          Get.back();
        });
      }
    });
  }
}
