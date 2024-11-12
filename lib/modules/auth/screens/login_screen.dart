import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/modules/auth/screens/ForgetPassord.dart';
import 'package:homework3/modules/auth/screens/register_screen.dart';
import 'package:homework3/modules/profile/screens/contact_us.dart';

import '../../../utils/Utilty.dart';
import '../../../utils/logo.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';
import '../controller/authentication_google_account.dart';

class LoginScreen extends StatefulWidget {
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
            shape: CircleBorder(),
            onPressed: () async {
              Get.to(ContactUsScreen());
            },
            child: const Icon(
              Icons.question_mark_rounded,
              color: Colors.white,
              size: 15,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                from: 10,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login to your\naccount',
                          style: context.textTheme.headlineLarge,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 99,
                          height: 4,
                          child: Image.asset(
                            'assets/images/accent.png',
                            color: mainColor,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Logo(),
                  ],
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Form(
                child: Column(
                  children: [
                    InputField(
                      hintText: 'Email',
                      autofocus: false,
                      suffixIcon: SizedBox(),
                      controller: emailController,
                    ),
                    SizedBox(
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
              const SizedBox(height: 15),
              FadeInDown(
                from: 20,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        ForgetPasswordScreen(
                          isChanged: false,
                        ),
                      );
                    },
                    child: Text(
                      'Forget Password?',
                    ),
                  ),
                ),
              ),
              SizedBox(
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
                      Get.back();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Center(
                child: Text(
                  'OR',
                ),
              ),
              SizedBox(
                height: 24,
              ),
              FadeInDown(
                from: 10,
                child: ElevatedButton(
                  onPressed: () async {
                    loadingDialog();
                    await GoogleSignInProvider().googleLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Image.asset(
                          'images/google.png',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Sign in with Google',
                        style: GoogleFonts.roboto(
                          color: Colors.black87,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(RegisterScreen());
                    },
                    child: Text(
                      'Register',
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
