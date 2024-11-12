import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/auth/controller/auth_controller.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/utils/logo.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../widgets/input_field.dart';
import '../../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({this.isAdmin = false});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
  final bool isAdmin;
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameCon = TextEditingController(text: '');
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController phCon = TextEditingController(text: '');

  final TextEditingController pwdCon = TextEditingController(text: '');
  final TextEditingController cfPwdCon = TextEditingController(text: '');

  bool passwordVisible = false;

  bool cfpasswordVisible = false;
  bool passwordConfrimationVisible = false;
  bool isChecked = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  void toggleCfPassword() {
    setState(() {
      cfpasswordVisible = !cfpasswordVisible;
    });
  }

  bool showBtn = false;
  checkBtn() {
    if (pwdCon.text.isNotEmpty &&
        cfPwdCon.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        nameCon.text.isNotEmpty &&
        phCon.text.isNotEmpty) {
      if (widget.isAdmin && userType.isNotEmpty) {
        showBtn = true;
      } else if (isChecked) {
        showBtn = true;
      }
    } else {
      showBtn = false;
    }
    setState(() {});
  }

  var userType = "";
  var listType = ["Admin", "Customer"];
  var authCon = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: widget.isAdmin
          ? customAppBar(
              title: "Create Customer Account",
              backgroundColor: Colors.white,
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: !widget.isAdmin,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register new\naccount',
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
              Visibility(
                visible: widget.isAdmin,
                child: Center(child: Logo()),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            hintText: 'User Name',
                            controller: nameCon,
                            suffixIcon: SizedBox(),
                            onChanged: (p0) {
                              checkBtn();
                            },
                          ),
                        ),
                        Visibility(
                            visible: widget.isAdmin,
                            child: Expanded(
                              child: FadeInDown(
                                from: 20,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        borderRadius: BorderRadius.circular(15),
                                        isDense: true,
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: grey.withOpacity(0.4),
                                          hintText: "User Type",
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 12),
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          userType = value!;
                                          checkBtn();
                                        },
                                        items: List.generate(listType.length,
                                            (index) {
                                          return DropdownMenuItem<String>(
                                            value: listType[index],
                                            child: Text(
                                              listType[index].trim(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    InputField(
                      delay: 100,
                      hintText: 'Phone Number',
                      controller: phCon,
                      keyboardType: TextInputType.phone,
                      suffixIcon: SizedBox(),
                      onChanged: (p0) {
                        checkBtn();
                      },
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    InputField(
                      delay: 200,
                      hintText: 'Email',
                      controller: emailController,
                      suffixIcon: SizedBox(),
                      onChanged: (p0) {
                        checkBtn();
                      },
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    InputField(
                      delay: 300,
                      hintText: 'Password',
                      controller: pwdCon,
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
                      onChanged: (p0) {
                        checkBtn();
                      },
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    InputField(
                      delay: 400,
                      hintText: 'Confirm Password',
                      controller: cfPwdCon,
                      onChanged: (p0) {
                        checkBtn();
                      },
                      obscureText: !cfpasswordVisible,
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        splashRadius: 1,
                        icon: SvgPicture.asset(
                          cfpasswordVisible
                              ? 'assets/icons/ic_eye.svg'
                              : 'assets/icons/ic_eye_close.svg',
                          color: Colors.grey,
                        ),
                        onPressed: toggleCfPassword,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              Visibility(
                visible: !widget.isAdmin,
                child: FadeInDown(
                  from: 10,
                  delay: Duration(milliseconds: 420),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                          checkBtn();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isChecked ? mainColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(4.0),
                            border: isChecked
                                ? null
                                : Border.all(color: mainColor, width: 1.5),
                          ),
                          width: 20,
                          height: 20,
                          child: isChecked
                              ? Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'By creating an account, you agree to our',
                          ),
                          Text(
                            'Terms & Conditions',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 22,
              ),
              FadeInDown(
                from: 10,
                delay: Duration(milliseconds: 480),
                child: CustomPrimaryButton(
                  buttonColor: showBtn ? mainColor : Colors.grey,
                  textValue: widget.isAdmin ? 'Create Account' : 'Register',
                  textColor: Colors.white,
                  onPressed: () {
                    if (showBtn) {
                      if (pwdCon.text != cfPwdCon.text) {
                        alertDialog(
                          desc:
                              'Your password and confirm password is not match!',
                        );
                      } else {
                        loadingDialog();
                        authCon.register(
                          userName: nameCon.text,
                          userType: userType,
                          isAdmin: widget.isAdmin,
                          email: emailController.text,
                          password: pwdCon.text,
                          ph: phCon.text,
                        );
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Visibility(
                visible: !widget.isAdmin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: Text(
                        'Login',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
