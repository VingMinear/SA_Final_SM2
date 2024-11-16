import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/slide_model.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../modules/home_screen/controller/product_controller.dart';

class MyBanner extends StatefulWidget {
  const MyBanner({super.key, required this.banner});
  final List<SlideModel> banner;
  @override
  State<MyBanner> createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  late final PageController pageController;

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
                    itemCount: 2,
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
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              top: 15, left: 10, right: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xffFBE9D7),
                                mainColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : widget.banner.isEmpty
                  ? Container(
                      height: 180,
                      width: double.infinity,
                      margin:
                          const EdgeInsets.only(top: 15, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.error, color: Colors.grey),
                    )
                  : FadeInDown(
                      from: 10,
                      child: CarouselSlider.builder(
                        itemCount: widget.banner.length,
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              pageNum = index;
                            });
                          },
                          height: 180,
                          viewportFraction: 1,
                          autoPlay: true,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          var banner = widget.banner[index];
                          return Container(
                            margin: const EdgeInsets.only(
                                top: 15, left: 10, right: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [
                                  HexColor('FFD368'),
                                  mainColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CustomCachedNetworkImage(
                              imgUrl: banner.img.image.value,
                            ),
                          );
                        },
                      ),
                    ),
          const SizedBox(
            height: 10,
          ),
          if (widget.banner.isNotEmpty)
            AnimatedSmoothIndicator(
              activeIndex: pageNum,
              count: widget.banner.length,
              effect: WormEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: HexColor('FFD368'),
                dotColor: Colors.grey.shade300,
              ),
            )
        ],
      ),
    );
  }
}
