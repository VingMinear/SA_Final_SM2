import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/home_screen/components/card_product_horizontal.dart';
import 'package:homework3/modules/home_screen/components/searching.dart';
import 'package:homework3/modules/home_screen/screens/list_product.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/EmptyProduct.dart';
import 'package:homework3/widgets/list_card_shimmer.dart';
import 'package:homework3/widgets/search.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/category.dart';
import '../../../widgets/bannerslide.dart';
import '../../../widgets/midletext.dart';
import '../controller/home_controller.dart';
import '../controller/product_controller.dart';
import 'hearder.dart';

class MainBody extends StatefulWidget {
  const MainBody({
    super.key,
  });

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  late final PageController pageController;

  int pageNum = 0;
  var con = Get.put(HomeController());
  var conPro = Get.put(ProductController());
  var categoryCon = Get.put(CategoryController());
  var loadingCategory = true.obs;
  @override
  void initState() {
    pageController = PageController(
      initialPage: 1,
      //viewportFraction: 0.92,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _getCategory();
      await conPro.getRecommentProducts();
    });
    super.initState();
  }

  Future<void> _getCategory() async {
    loadingCategory(true);
    await categoryCon.fetchCategory();
    loadingCategory(false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await conPro.getRecommentProducts();
        await _getCategory();
        setState(() {});
      },
      child: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 0),
                children: [
                  FadeInDown(
                    from: 5,
                    child: Column(
                      children: [
                        const HomeAppBar(),
                        GestureDetector(
                          onTap: () {
                            debugPrint('Tap');
                            Get.to(
                              const Searching(),
                            );
                          },
                          child: const SearchBarWidget(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 3,
                        ),

                        MyBanner(
                          banner: con.slidesBanner,
                        ),

                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        // menu icons
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: categoryCon.homeCategries.length,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisExtent: 100,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            maxCrossAxisExtent: 77,
                          ),
                          itemBuilder: ((context, index) {
                            final data = categoryCon.homeCategries[index];

                            return loadingCategory.value
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.grey.shade100,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        line(
                                          width: 60,
                                          height: 15,
                                          raduis: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                : AnimationLimiter(
                                    child: AnimationConfiguration.staggeredGrid(
                                      columnCount: 2,
                                      position: index,
                                      child: FadeIn(
                                        child: FadeInDown(
                                          from: 5,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          delay: Duration(
                                              milliseconds: 100 * index),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                () => ListProducts(
                                                  title: data.title,
                                                  categoryId: data.id,
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    boxShadow: shadow,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: SizedBox(
                                                      width: 33,
                                                      height: 33,
                                                      child:
                                                          CustomCachedNetworkImage(
                                                        imgUrl: data
                                                            .icon.image.value,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                FittedBox(
                                                  child: Text(
                                                    data.title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const MidleText(),

                        const SizedBox(
                          height: 15,
                        ),

                        conPro.loadingNewCollection.value
                            ? buildShimmerGrid()
                            : conPro.listRecommentProduct.isEmpty
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 40),
                                      child: EmptyProduct(
                                          desc: 'No product found'),
                                    ),
                                  )
                                : AnimationLimiter(
                                    child: ListView.separated(
                                      itemCount:
                                          conPro.listRecommentProduct.length,
                                      shrinkWrap: true,
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var data =
                                            conPro.listRecommentProduct[index];
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 375),
                                          child: FadeInAnimation(
                                              child: CardProductHorizontal(
                                                  product: data)),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 10);
                                      },
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerGrid() {
    return ListView.separated(
      itemCount: 6,
      padding: const EdgeInsets.only(bottom: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return const ListShimmer(
          height: 90,
        );
      },
    );
  }
}
