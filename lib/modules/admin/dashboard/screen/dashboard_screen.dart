import 'package:animate_do/animate_do.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/admin/dashboard/controller/dashboard_con.dart';
import 'package:homework3/modules/admin/dashboard/screen/editing_category_screen.dart';
import 'package:homework3/modules/admin/product/screen/adproduct_screen.dart';
import 'package:homework3/modules/admin/report/screen/report.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../utils/Date.dart';
import '../../../../utils/Utilty.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/style.dart';
import '../../../../widgets/CustomCachedNetworkImage.dart';
import '../../../../widgets/PhotoViewDetail.dart';
import '../../../../widgets/SplashButton.dart';
import '../../order/screens/order_screen.dart';
import '../../user/screen/admin_user.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  get shadow => BoxShadow(
        color: AppColor.shadowColor,
        offset: const Offset(2, 2),
        blurRadius: 0.5,
      );
  DashboardCon con = Get.put(DashboardCon());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  Future fetchData() async {
    await con.fetchDataHome();
  }

  int touchedIndex = -1;
  var user = GlobalClass().user.value;
  @override
  Widget build(BuildContext context) {
    var listMenu = <Map>[
      {
        'title': 'Order',
        'icon': 'assets/icons/home/ic_order.svg',
      },
      {
        'title': 'Product',
        'icon': 'assets/icons/home/ic_cart.svg',
      },
      {
        'title': 'User',
        'icon': 'assets/icons/ic_user.svg',
      },
      {
        'title': 'Report',
        'icon': 'assets/icons/status-up.svg',
      },
    ];
    var gradient = <List<Color>>[
      [
        const Color(0xffA86FEB),
        const Color(0xff7724E4),
      ],
      [
        const Color(0xffFC9F66),
        const Color(0xffFB7B30),
      ],
      [
        const Color(0xff6DA0FC),
        const Color(0xff3974D6),
      ],
      [
        const Color(0xff7CE566),
        const Color(0xff38B41F),
      ],
    ];
    var today = DateTime.now();

    var last7Days = today.subtract(const Duration(days: 7));
    var dateDisplay =
        "${Date.month(last7Days)} ${Date.day(last7Days)} - ${DateFormat('MMM d, yyyy').format(today)}";

    var edgeOffset = Get.context!.mediaQueryViewPadding.top;

    double paddingScreen() {
      return 10;
    }

    var gredient = const LinearGradient(
      colors: [
        Color(0xff4AB8F3),
        Color(0xff9ADFF5),
      ],
      end: Alignment.topCenter,
      begin: Alignment.bottomRight,
    );
    return Scaffold(
      backgroundColor: AppColor.bgScaffold,
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            await con.fetchDataHome();
          },
          displacement: 8,
          edgeOffset: edgeOffset,
          child: SafeArea(
            child: SizedBox(
              height: appHeight(),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Column(
                  children: [
                    // header
                    Offstage(
                      offstage: false,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: gredient,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: SafeArea(
                          bottom: false,
                          child: DefaultTextStyle(
                            style: AppText.txt14.copyWith(
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: paddingScreen(),
                                      right: 10,
                                      top: 15),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                    PhotoViewDetail(
                                                      imageUrl: user.photo,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  child:
                                                      CustomCachedNetworkImage(
                                                    imgUrl: user.photo,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${'Welcome Back'.tr} 👋🏻',
                                                  ),
                                                  Text(
                                                    "${user.name}",
                                                    style:
                                                        AppText.txt16.copyWith(
                                                      color:
                                                          AppColor.whiteColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                          horizontal: paddingScreen())
                                      .copyWith(
                                          top: 10, bottom: paddingScreen()),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'total value'.tr.toUpperCase(),
                                              style: AppText.txt15.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  ('last 7 days'),
                                                  style: AppText.txt11.copyWith(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  dateDisplay,
                                                  style: AppText.txt11.copyWith(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      DefaultTextStyle(
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: (26),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '\$${con.totalAmount.toStringAsFixed(2)}',
                                            ),
                                            const Text(
                                              ' / ',
                                            ),
                                            Text(
                                              '${con.totalOrder}',
                                            ),
                                            Text(
                                              ' ${'orders'.tr}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: (15),
                                                fontWeight: FontWeight.normal,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // body
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        gradient: gredient,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 6),
                      child: const Text(
                        "Menu",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: mainColor, width: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        itemCount: listMenu.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 120,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        padding: EdgeInsets.all(paddingScreen()),
                        itemBuilder: (context, index) {
                          var item = listMenu[index];
                          return SplashButton(
                            vertical: 0,
                            // color: Colors.transparent,
                            gradient: gredient,
                            boxShadow: const [],
                            onTap: () {
                              Get.to(() {
                                switch (index) {
                                  case 0:
                                    return const AdminOrderScreen();
                                  case 1:
                                    return const AdminProductScreen();
                                  case 2:
                                    return const AdminUser();
                                  default:
                                    return Report(
                                      totalOrder: con.totalOrder.value,
                                    );
                                }
                              })!
                                  .then((value) async {
                                await con.fetchDataHome();
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      item['icon'],
                                      color: whiteColor,
                                      width: (30),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      item['title'],
                                      style: AppText.txt15.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: index == 0,
                                  child: Obx(
                                    () => Positioned(
                                      right: 7,
                                      top: 0,
                                      child: badge(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const EditingCategoryScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradient[2],
                              begin: Alignment.topRight,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 0,
                                offset: const Offset(3, 3),
                                blurRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.category,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 20),
                              Flexible(
                                child: Text(
                                  "Categorys",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    MaterialButton(
                      elevation: 0,
                      color: const Color(0xFFF75555),
                      highlightElevation: 0,
                      onPressed: () {
                        alertDialogConfirmation(
                          title: 'Logout',
                          desc: 'Are you sure you want to logout?',
                          onConfirm: () {
                            Get.back();
                            logOut();
                          },
                        );
                      },
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0,
                          color: Colors.red.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/profile/logout@2x.png',
                            scale: 2,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Logout",
                            style: AppText.txt15.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        height: kBottomNavigationBarHeight,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xff4AB8F3),
              Color(0xff9ADFF5),
            ],
            end: Alignment.topCenter,
            begin: Alignment.bottomRight,
          ),
        ),
        child: FadeIn(
          child: const Center(
              child: Text(
            'App Version : 1.0 | Copyright © by SS5',
            style: TextStyle(fontSize: 13),
          )),
        ),
      ),
    );
  }

  badge() {
    var badgeCount =
        con.newOrder.value > 99 ? '99+' : con.newOrder.value.toString();
    return badges.Badge(
      showBadge: con.newOrder.value != 0 ? true : false,
      ignorePointer: false,
      position: badges.BadgePosition.topEnd(
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
            badges.SlideTween(begin: Offset(-0.05, 0.1), end: Offset(0.0, 0.0)),
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
    );
  }
}
