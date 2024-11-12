import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/auth/screens/splash_screen.dart';
import 'package:homework3/theme/Theme.dart';
import 'package:homework3/utils/DismissKeyboard.dart';
import 'package:homework3/utils/LocalStorage.dart';
import 'package:homework3/utils/api_base_helper.dart';

import 'firebase_options.dart';
import 'modules/auth/controller/cloud_fire_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await LocalNotificationHandler.initLocalNotification();
  // await NotificationHandler().initNotification();
  await LocalStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  if (!kDebugMode) {
    await CloudFireStore.getServerURl().then((value) {
      if (value.isNotEmpty) {
        baseurl = "http://${value}:8080/";
      }
    });
  }
  FlutterNativeSplash.remove();
  runApp(MyApp());
}

late BuildContext globalContext;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return DismissKeyboard(
      child: GetMaterialApp(
        defaultTransition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300),
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: SplashScreen(),
      ),
    );
  }
}
