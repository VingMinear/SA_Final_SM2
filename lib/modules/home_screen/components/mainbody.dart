import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/home_screen/components/card_favorite.dart';
import 'package:homework3/modules/home_screen/components/searching.dart';
import 'package:homework3/modules/home_screen/screens/list_product.dart';
import 'package:homework3/modules/home_screen/screens/product_detail.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/list_card_shimmer.dart';
import 'package:homework3/widgets/search.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/category.dart';
import '../../../widgets/bannerslide.dart';
import '../../../widgets/grid_card_shimmer.dart';
import '../../../widgets/midletext.dart';
import '../../../widgets/product_card.dart';
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
  @override
  void initState() {
    pageController = PageController(
      initialPage: 1,
      //viewportFraction: 0.92,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await categoryCon.fetchCategory();
      await conPro.getRecommentProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await conPro.getRecommentProducts();
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

                        const MyBanner(),

                        const Text(
                          "New Collections",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 135,
                          width: double.infinity,
                          padding: EdgeInsets.zero,
                          child: conPro.loadingNewCollection.value
                              ? ListView.separated(
                                  itemCount: 4,
                                  scrollDirection: Axis.horizontal,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => SizedBox(
                                    width: context.width * 0.85,
                                    child: const ListShimmer(),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 10),
                                )
                              : conPro.listCollectionProduct.isEmpty
                                  ? const Center(
                                      child: Text("No Product found"))
                                  : FadeInDown(
                                      from: 5,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: ListView.separated(
                                        itemCount:
                                            conPro.listCollectionProduct.length,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            AnimationConfiguration
                                                .staggeredList(
                                          position: index,
                                          child: SizedBox(
                                            width: context.width * 0.85,
                                            child: CardListProduct(
                                              product: conPro
                                                  .listCollectionProduct[index],
                                            ),
                                          ),
                                        ),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(width: 10),
                                      ),
                                    ),
                        ),
                        const SizedBox(height: 20),
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

                            return conPro.loadingNewCollection.value
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
                          height: 20,
                        ),

                        conPro.loadingNewCollection.value
                            ? buildShimmerGrid()
                            : conPro.listRecommentProduct.isEmpty
                                ? const Center(child: Text("No Product found"))
                                : AnimationLimiter(
                                    child: GridView.builder(
                                      itemCount:
                                          conPro.listRecommentProduct.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 15,
                                        crossAxisSpacing: 15,
                                        mainAxisExtent: 245,
                                      ),
                                      shrinkWrap: true,
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var data =
                                            conPro.listRecommentProduct[index];
                                        return AnimationConfiguration
                                            .staggeredGrid(
                                          columnCount: 2,
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 375),
                                          child: FadeInAnimation(
                                            child: ProductCard(
                                              data: data,
                                              isAdmin: false,
                                              ontap: (data) {
                                                Get.to(
                                                  ProductDetailsView(
                                                      product: data),
                                                );
                                              },
                                            ),
                                          ),
                                        );
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

  GridView buildShimmerGrid() {
    return GridView.builder(
      itemCount: 6,
      padding: const EdgeInsets.only(bottom: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        mainAxisExtent: 245,
      ),
      itemBuilder: (context, index) {
        return const GridShimmer(
          isAdmin: false,
        );
      },
    );
  }
}
