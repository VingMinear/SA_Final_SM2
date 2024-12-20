import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/model/user_model.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/SingleTon.dart';
import '../../admin/dashboard/screen/dashboard_screen.dart';
import '../../bottom_navigation_bar/bottom_navigatin_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.logout = false});
  final bool logout;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(milliseconds: 1800),
        () {
          checkUser();
        },
      );
    });
    super.initState();
  }

  var scale = 1.0;

  checkUser() async {
    if (widget.logout) {
      GlobalClass().user.value = UserModel();
    }
    if (GlobalClass().isUserLogin) {
      await AuthController().getUser();
      scale = 0;
      setState(() {});
      Future.delayed(
        const Duration(milliseconds: 310),
        () {
          if (GlobalClass().user.value.isAdmin) {
            Get.offAll(const DashboardScreen());
          } else {
            Get.offAll(const BottomNavigationBarScreen());
          }
        },
      );
    } else {
      scale = 0;
      setState(() {});
      Get.offAll(const BottomNavigationBarScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.red,
    ];
    var colorizeTextStyle = const TextStyle(
      fontSize: 50.0,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: scale,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/splashscreen.json',
                    width: 350,
                  ),
                  FadeIn(
                    child: ElasticIn(
                      delay: const Duration(milliseconds: 500),
                      child: SizedBox(
                        height: 100,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'SS5 Reads',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                            ),
                          ],
                          repeatForever: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
