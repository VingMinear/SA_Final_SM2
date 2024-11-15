import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/auth/screens/splash_screen.dart';
import 'package:homework3/theme/Theme.dart';
import 'package:homework3/utils/DismissKeyboard.dart';
import 'package:homework3/utils/LocalNotificationHandler.dart';
import 'package:homework3/utils/LocalStorage.dart';
import 'package:homework3/utils/NotificationHandler.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificationHandler.initLocalNotification();
  await NotificationHandler().initNotification();
  await LocalStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

late BuildContext globalContext;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return DismissKeyboard(
      child: GetMaterialApp(
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 300),
        debugShowCheckedModeBanner: false,
        theme: theme(),
        builder: (context, child) {
          return LoaderOverlay(
            overlayWidgetBuilder: (progress) {
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: shadow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const FittedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: mainColor,
                    ),
                  ),
                ),
              );
            },
            child: child!,
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
