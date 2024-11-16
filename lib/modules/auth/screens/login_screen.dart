import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/modules/auth/screens/register_screen.dart';
import 'package:homework3/modules/profile/screens/contact_us.dart';

import '../../../utils/Utilty.dart';
import '../../../utils/logo.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  var authCon = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            elevation: 2,
            tooltip: "Click to contact us",
            backgroundColor: Colors.black.withOpacity(0.6),
            shape: const CircleBorder(),
            onPressed: () async {
              Get.to(const ContactUsScreen());
            },
            child: const Icon(
              Icons.question_mark_rounded,
              color: Colors.white,
              size: 15,
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Login to your account',
          style: context.textTheme.headlineLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Center(child: Logo()),
              const SizedBox(
                height: 20,
              ),
              Form(
                child: Column(
                  children: [
                    InputField(
                      hintText: 'Email',
                      autofocus: false,
                      suffixIcon: const SizedBox(),
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    InputField(
                      delay: 100,
                      autofocus: false,
                      hintText: 'Password',
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        splashRadius: 1,
                        icon: SvgPicture.asset(
                          passwordVisible
                              ? 'assets/icons/ic_eye.svg'
                              : 'assets/icons/ic_eye_close.svg',
                          color: Colors.grey,
                        ),
                        onPressed: togglePassword,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 15),
              // FadeInDown(
              //   from: 20,
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: GestureDetector(
              //       onTap: () {
              //         Get.to(
              //           const ForgetPasswordScreen(
              //             isChanged: false,
              //           ),
              //         );
              //       },
              //       child: const Text(
              //         'Forget Password?',
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 32,
              ),
              FadeInDown(
                from: 19,
                child: CustomPrimaryButton(
                  textValue: 'Login',
                  textColor: Colors.white,
                  onPressed: () async {
                    dismissKeyboard(context);
                    var email = emailController.text.trim();
                    var pwd = passwordController.text.trim();
                    if (email.isEmpty || pwd.isEmpty) {
                      if (email.isEmpty) {
                        alertDialog(desc: 'Please enter your email.');
                      } else {
                        alertDialog(desc: 'Please enter your password.');
                      }
                    } else {
                      loadingDialog();
                      await authCon.login(
                        name: email,
                        pwd: pwd,
                      );
                      popLoadingDialog();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(const RegisterScreen());
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: mainColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
