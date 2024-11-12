import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/auth/screens/ForgetPassord.dart';
import 'package:homework3/modules/profile/screens/edit_profile_screen.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../components/header.dart';
import 'address_screen.dart';
import 'contact_us.dart';
import 'order_screen.dart';

typedef ProfileOptionTap = void Function();

class ProfileOption {
  String title;
  String icon;
  Color? titleColor;
  ProfileOptionTap? onClick;
  Widget? trailing;

  ProfileOption({
    required this.title,
    required this.icon,
    this.onClick,
    this.titleColor,
    this.trailing,
  });

  ProfileOption.arrow({
    required this.title,
    required this.icon,
    this.onClick,
    this.titleColor = const Color(0xFF212121),
    this.trailing = const Image(
        image: AssetImage('assets/icons/profile/arrow_right@2x.png'),
        width: 20,
        height: 20),
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static _profileIcon(String last) => 'assets/icons/profile/$last';
  List get datas => <ProfileOption>[
        ProfileOption.arrow(
            title: 'Edit Profile', icon: _profileIcon('profile@2x.png')),
        ProfileOption.arrow(title: 'Order', icon: _profileIcon('order.png')),
        ProfileOption.arrow(
            title: 'Address', icon: _profileIcon('location@2x.png')),
        ProfileOption.arrow(
            title: 'Change Password', icon: _profileIcon('lock@2x.png')),
        ProfileOption.arrow(
            title: 'Contact Us', icon: _profileIcon('user@2x.png')),
        ProfileOption(
          title: 'Logout',
          icon: _profileIcon('logout@2x.png'),
          titleColor: const Color(0xFFF75555),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Profile",
        useLeadingCustom: false,
        showNotification: false,
      ),
      body: ListView(
        children: [
          FadeIn(
            child: const Padding(
              padding:
                  EdgeInsets.only(top: 30, left: 20, right: 10, bottom: 40),
              child: ProfileHeader(),
            ),
          ),
          _buildBody(),
          const SizedBox(height: 40),
          FadeIn(
            child: const Center(
                child: Text(
              'App Version : 1.0 | Copyright © by SS5',
              style: TextStyle(fontSize: 13),
            )),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 10.0),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: List.generate(
            datas.length,
            (index) {
              final data = datas[index];
              return FadeInLeft(
                from: 14,
                delay: Duration(milliseconds: 50 * index),
                child: _buildOption(context, index, data),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index, ProfileOption data) {
    return ListTile(
      leading: Image.asset(
        data.icon,
        width: 20,
      ),
      minLeadingWidth: 20,
      title: Text(
        data.title,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 16, color: data.titleColor),
      ),
      trailing: data.trailing,
      onTap: () {
        switch (index) {
          case 0:
            Get.to(const EditProfileScreen());
            break;
          case 1:
            Get.to(const OrderScreen());
            break;
          case 2:
            Get.to(AddressScreen());
            break;
          case 3:
            Get.to(const ForgetPasswordScreen(
              isChanged: true,
            ));
            break;
          case 4:
            Get.to(const ContactUsScreen());
            break;
          case 5:
            alertDialogConfirmation(
              title: "Logout",
              desc: "Are you sure you want to Logout ?",
              onConfirm: () {
                logOut();
              },
            );
            break;
        }
      },
    );
  }
}
