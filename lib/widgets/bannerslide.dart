import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../model/banner.dart';
import '../modules/home_screen/controller/product_controller.dart';
import '../modules/home_screen/screens/list_product.dart';

class MyBanner extends StatefulWidget {
  const MyBanner({super.key});

  @override
  State<MyBanner> createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  late final PageController pageController;
  List<BannerSlide> banner = BannerSlide.listBanner();
  int pageNum = 0;
  @override
  void initState() {
    pageController = PageController(
      initialPage: 1,
      //viewportFraction: 0.92,
    );
    super.initState();
  }

  var conPro = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          conPro.loadingNewCollection.value
              ? FadeInDown(
                  from: 10,
                  child: CarouselSlider.builder(
                    itemCount: banner.length,
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {
                          pageNum = index;
                        });
                      },
                      viewportFraction: 1,
                      autoPlay: true,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.grey.shade100,
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 15, left: 10, right: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xffF6D5F7),
                                    Color(0xffFBE9D7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            banner[index].text,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              shadows: [
                                                BoxShadow(
                                                  color: Color(0xffF6D5F7),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: (() {
                                              Get.to(
                                                () => ListProducts(
                                                  title: banner[index].title,
                                                  categoryId:
                                                      banner[index].categoryId,
                                                ),
                                              );
                                            }),
                                            child: Container(
                                              width: 120,
                                              height: 32,
                                              padding: const EdgeInsets.all(5)
                                                  .copyWith(
                                                      left: 10, right: 10),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                gradient: LinearGradient(
                                                  end: Alignment.bottomRight,
                                                  begin: Alignment.topLeft,
                                                  colors: [
                                                    Color(0xFFF2654B),
                                                    //Color(0xFFF34220),
                                                    Color(0xFFF3480F),
                                                  ],
                                                ),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                banner[index].btn,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                AssetImage(banner[index].image),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : FadeInDown(
                  from: 10,
                  child: CarouselSlider.builder(
                    itemCount: banner.length,
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {
                          pageNum = index;
                        });
                      },
                      viewportFraction: 1,
                      autoPlay: true,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ListProducts(
                              title: banner[index].title,
                              categoryId: banner[index].categoryId,
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 15, left: 10, right: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xffF6D5F7),
                                    Color(0xffFBE9D7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            banner[index].text,
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              shadows: [
                                                BoxShadow(
                                                  color: Color(0xffF6D5F7),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 120,
                                            height: 32,
                                            padding: const EdgeInsets.all(5)
                                                .copyWith(left: 10, right: 10),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                              ),
                                              gradient: LinearGradient(
                                                end: Alignment.bottomRight,
                                                begin: Alignment.topLeft,
                                                colors: [
                                                  Color(0xFFF2654B),
                                                  //Color(0xFFF34220),
                                                  Color(0xFFF3480F),
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              banner[index].btn,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                AssetImage(banner[index].image),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          AnimatedSmoothIndicator(
            activeIndex: pageNum,
            count: banner.length,
            effect: WormEffect(
              dotWidth: 13,
              dotHeight: 13,
              activeDotColor: const Color(0xffFBE9D7),
              dotColor: Colors.grey.shade200,
            ),
          )
        ],
      ),
    );
  }
}
