import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/auth/screens/login_screen.dart';
import 'package:homework3/modules/bottom_navigation_bar/bottom_controller.dart';
import 'package:homework3/modules/cart/screens/cart_screen.dart';
import 'package:homework3/modules/favorite/screens/favorite_screen.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/widgets/google_map.dart';
import 'package:iconsax/iconsax.dart';

import '../cart/controllers/cart_controller.dart';
import '../home_screen/screens/home_screen.dart';
import '../profile/screens/profile_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  static List<Widget> pages = <Widget>[
    const HomePage(),
    const FavoriteScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];
  int selected = 0;
  var pageController = PageController();
  int currentIndex = 0;
  List label = [
    "Home",
    "Borrow",
    "Personal",
  ];
  List<IconData> icon = [
    Boxicons.bx_home,
    Boxicons.bx_book,
    CupertinoIcons.person,
  ];

  // ignore: unused_field
  static TextStyle optionStyle =
      const TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    Get.put(MapController()).customMarkerIcon();
    Future.delayed(
      const Duration(milliseconds: 800),
      () {
        Get.put(MapController()).currentLocaton();
      },
    );
    var con = Get.put(BottomController());

    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xffFBFAF6),
        body: pages.elementAt(con.selectedIndex.value),
        // floatingActionButton:

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //---------bottom---------//

        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            gap: 10,
            selectedIndex: con.selectedIndex.value,
            activeColor: Colors.white,
            color: Colors.black54,
            tabBackgroundColor: mainColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            duration: const Duration(milliseconds: 400),
            onTabChange: (index) {
              con.selectedIndex(index);
            },
            tabs: [
              const GButton(
                icon: Iconsax.home,
                text: 'Home',
              ),
              const GButton(
                icon: Iconsax.heart,
                text: 'Favorites',
              ),
              GButton(
                icon: Icons.shop,
                text: 'Cart',
                leading: cartIcon(
                  con.selectedIndex.value == 2 ? Colors.white : Colors.black54,
                ),
              ),
              const GButton(
                icon: Iconsax.user,
                text: 'Profile',
              )
            ],
          ),
        ),
      ),
    );
  }
}

cartIcon(Color iconColor) {
  var cartController = Get.put(CartController());
  var lenghtBadge = cartController.shoppingCart.length;
  var badgeCount = lenghtBadge > 9 ? '9+' : lenghtBadge.toString();
  return badges.Badge(
    showBadge: lenghtBadge != 0 ? true : false,
    ignorePointer: false,
    position: BadgePosition.topEnd(
      top: -5,
      end: -5,
    ),
    badgeContent: Text(
      badgeCount,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 9,
      ),
    ),
    badgeAnimation: const badges.BadgeAnimation.slide(
      slideTransitionPositionTween:
          SlideTween(begin: Offset(-0.05, 0.1), end: Offset(0.0, 0.0)),
      animationDuration: Duration(seconds: 1),
      colorChangeAnimationDuration: Duration(seconds: 1),
      loopAnimation: false,
      curve: Curves.fastOutSlowIn,
      colorChangeAnimationCurve: Curves.easeInCubic,
    ),
    badgeStyle: badges.BadgeStyle(
      shape: badges.BadgeShape.circle,
      badgeColor: Colors.red,
      padding: EdgeInsets.all(badgeCount.length >= 2 ? 5 : 6.5),
      borderRadius: BorderRadius.circular(4),
      elevation: 0,
    ),
    child: Image.asset(
      'images/cart.png',
      width: 23.5,
      color: iconColor,
    ),
  );
}
