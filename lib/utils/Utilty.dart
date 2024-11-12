import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/auth/screens/splash_screen.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/utils/style.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/color.dart';
import '../model/user_model.dart';
import '../modules/auth/controller/authentication.dart';
import '../widgets/CustomButton.dart';
import '../widgets/primary_button.dart';
import 'LocalStorage.dart';

const String kIconPath = 'assets/icons';
const String myImgUrl =
    'https://lh3.googleusercontent.com/a/ACg8ocIH_3zFamOQ46B_GgvHZ3lCBAsxHiuje4ku9RDe-7Wgf3A=s360-c-no';
dismissKeyboard(BuildContext context) {
  final FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}

showTaost(String desc) {
  Fluttertoast.showToast(
    msg: desc,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey.withOpacity(0.59),
    textColor: whiteColor,
    fontSize: 15.0,
  );
}

//----------prefix---------------
// url > https:
// email to > mailto:
// call > tel:
// message > sms:
Future<bool> callLaunchUrl({
  required String url,
  LaunchMode mode = LaunchMode.externalApplication,
  WebViewConfiguration? webViewConfiguration,
}) async {
  try {
    if (!await launchUrl(
      Uri.parse(url),
      mode: mode,
    )) {
      debugPrint('Could not launch : $url');
      return false;
    } else {
      return true;
    }
  } on Exception catch (e) {
    debugPrint('Erorr: $e');
    return false;
  }
}

extension Context on BuildContext {
  ThemeData get theme => Theme.of(this);
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}

extension Format on double {
  String get formatCurrency {
    final result = NumberFormat("#,##0.00", "en_US");
    return result.format(this);
  }
}

loadingDialog() async {
  await Get.dialog(
    AlertDialog(
      surfaceTintColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 110),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        height: 50,
        width: 10,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: shadow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: FittedBox(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: mainColor,
          ),
        ),
      ),
    ),
    barrierColor: Colors.transparent,
    barrierDismissible: false,
  );
}

double appHeight({double percent = 1}) {
  return MediaQuery.of(Get.context!).size.height * percent;
}

double appWidth({double percent = 1}) {
  return MediaQuery.of(Get.context!).size.width * percent;
}

Future pushScreenWidget(
  Widget Function() screen, {
  dynamic arguments,
  Transition? transition,
}) async {
  await Get.to(
    screen,
    arguments: arguments,
    transition: transition,
    preventDuplicates: true,
  );
}

alertDialogConfirmation({
  String? title,
  String? desc,
  String? txtBtnCfn,
  String? txtBtnCancel,
  Color? btnCancelColor,
  void Function()? onConfirm,
}) {
  Get.dialog(
    Builder(
      builder: (context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? "",
                  style: context.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Text(desc ?? '', textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        borderSide:
                            BorderSide(color: btnCancelColor ?? mainColor),
                        backgroundColor: Colors.transparent,
                        textStyle: context.textTheme.bodyLarge!
                            .copyWith(color: btnCancelColor ?? mainColor),
                        title: txtBtnCancel ?? 'Cancel',
                        onPress: () {
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButton(
                        title: txtBtnCfn ?? 'Confirm',
                        onPress: () {
                          onConfirm!();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    ),
  );
}

void logOut() async {
  LocalStorage.removeData(key: "user_id");
  GlobalClass().user.value = UserModel();
  await Authentication().signOut();
  Get.offAll(SplashScreen());
}

Future<void> alertDialog({
  String? title,
  required String desc,
  String? txtBtn,
  void Function()? onCf,
  bool barrierDismissible = true,
  bool showBarrierColor = true,
}) async {
  await Get.dialog(
    Builder(
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return barrierDismissible ? true : false;
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
                    top: 40,
                    bottom: 10,
                  ),
                  margin: const EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title ?? 'Ops',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        desc,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: appWidth() / 3,
                          child: CustomPrimaryButton(
                            textValue: 'Ok',
                            textColor: Colors.white,
                            onPressed: onCf ??
                                () {
                                  Get.back();
                                },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'images/warning.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

customalertDialogConfirmation({
  String? title,
  String? desc,
  String? txtBtnCfn,
  String? txtBtnCancel,
  Widget? child,
  void Function()? onConfirm,
  EdgeInsetsGeometry? paddingBody,
  EdgeInsetsGeometry? paddingButton,
  bool barrierDismissible = true,
}) async {
  await showDialog(
    context: Get.context!,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return barrierDismissible;
        },
        child: Dialog(
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((14)),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title ?? '',
                        style: AppText.txt16.copyWith(),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.clear_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: paddingBody ??
                      const EdgeInsets.all(20.0).copyWith(top: 10),
                  child: Column(
                    children: [
                      child ?? const SizedBox.shrink(),
                      Padding(
                        padding: paddingButton ??
                            const EdgeInsets.all(20.0).copyWith(top: 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                backgroundColor: Colors.transparent,
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                                textStyle: btnTextStyle(
                                  color: Colors.red,
                                ),
                                title: txtBtnCancel ?? 'cancel'.tr,
                                onPress: () {
                                  Get.back();
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: CustomButton(
                                title: txtBtnCfn ?? 'cf'.tr,
                                onPress: onConfirm ?? () {},
                                textStyle: btnTextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
