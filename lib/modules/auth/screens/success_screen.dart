import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/Color.dart';
import '../../../widgets/CustomButton.dart';
import '../../../widgets/custom_appbar.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key, required this.desc, this.titleBtn, this.onPress});
  final String desc;
  final String? titleBtn;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(showNotification: false),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: context.height * 0.05),
              Lottie.asset(
                'images/success.json',
                repeat: false,
                width: 130,
                fit: BoxFit.cover,
                height: 130,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          onPress: onPress ??
              () {
                Get.until(
                  (route) => route.isFirst,
                );
              },
          title: titleBtn ?? 'Back to Login',
        ),
      ),
    );
  }
}
