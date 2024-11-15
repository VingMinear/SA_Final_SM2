import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/product_model.dart';
import 'package:homework3/modules/auth/screens/login_screen.dart';
import 'package:homework3/modules/cart/controllers/cart_controller.dart';
import 'package:homework3/modules/cart/screens/check_out_screen.dart';
import 'package:homework3/modules/home_screen/controller/product_controller.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/widgets/product_card.dart';

import '../../../utils/Utilty.dart';
import '../../../widgets/CustomCachedNetworkImage.dart';
import '../../../widgets/grid_card_shimmer.dart';
import '../../bottom_navigation_bar/bottom_navigatin_bar.dart';
import '../../cart/models/cart_model.dart';
import '../../cart/screens/cart_screen.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final cartCon = Get.put(CartController());
  final con = Get.put(ProductController());
  var loading = true;
  ProductModel productDetail = ProductModel();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      debugPrint('My DebugPrint : ${widget.product.productId}');
      await con.getProductDetail(pId: widget.product.productId!).then((value) {
        productDetail = value;
      });
      productDetail;
      loading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: whiteColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            shadowColor: grey,
            backgroundColor: whiteColor,
          ),
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(const CartScreen(
                back: true,
              ));
            },
            child: cartIcon(
              Colors.black54,
            ),
          ),
          const SizedBox(width: 15),
        ],
        elevation: 0,
        shadowColor: Colors.white,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await con
                    .getProductDetail(pId: widget.product.productId!)
                    .then((value) {
                  productDetail = value;
                  setState(() {});
                });
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: appHeight() * 0.4,
                      padding: const EdgeInsets.all(25),
                      decoration: const BoxDecoration(
                        boxShadow: [],
                      ),
                      child: FittedBox(
                        child: CustomCachedNetworkImage(
                          imgUrl: productDetail.image ?? '',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.11),
                            spreadRadius: -1,
                            blurRadius: 10,
                          ),
                        ],
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buildTitle(),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ..._buildDescription(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Similar Products :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    FutureBuilder<List<ProductModel>>(
                      future: con.getProductByCategory(
                        categoryId: widget.product.categoryId!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return AnimationLimiter(
                            child: GridView.builder(
                              itemCount: 5,
                              padding: const EdgeInsets.only(
                                  bottom: 20, left: 20, right: 20, top: 20),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                mainAxisExtent: 245,
                              ),
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredGrid(
                                  columnCount: 2,
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: const FadeInAnimation(
                                      child: GridShimmer(
                                    isAdmin: false,
                                  )),
                                );
                              },
                            ),
                          );
                        } else {
                          var products = snapshot.data!;
                          products.removeWhere((element) =>
                              element.productId == widget.product.productId);
                          products.shuffle();
                          return AnimationLimiter(
                            child: GridView.builder(
                              itemCount: products.length,
                              padding: const EdgeInsets.only(
                                  bottom: 20, left: 20, right: 20, top: 20),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                mainAxisExtent: 245,
                              ),
                              itemBuilder: (context, index) {
                                var data = products[index];

                                return AnimationConfiguration.staggeredGrid(
                                  columnCount: 2,
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: FadeInAnimation(
                                    child: ProductCard(
                                      data: data,
                                      isAdmin: false,
                                      ontap: (data) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsView(
                                                    product: data),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(color: whiteColor, boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.1),
            spreadRadius: -1,
            blurRadius: 10,
          ),
        ]),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: _buldFloatBar(),
      ),
    );
  }

  List<Widget> _buildTitle() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25).copyWith(top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '${productDetail.productName}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            const SizedBox(width: 10),
            Text('\$${productDetail.priceOut}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25).copyWith(right: 19),
        child: Row(
          children: [
            Text(
              productDetail.categoryName ?? '',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: Color(0xFFeeeeee),
              ),
              child: Text(
                '${productDetail.sold} sold',
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 16),
            const Spacer(),
            IconButton(
              style: ElevatedButton.styleFrom(
                elevation: 1,
                shadowColor: grey,
                backgroundColor: whiteColor,
              ),
              onPressed: () async {
                if (productDetail.isFav) {
                  // removed
                  con
                      .updFavorite(
                    proId: productDetail.productId!,
                    isFav: productDetail.isFav,
                  )
                      .then((value) {
                    _showTaost(true);
                  });
                } else {
                  //add
                  con
                      .addFavorite(
                    proId: productDetail.productId!,
                  )
                      .then((value) {
                    _showTaost(false);
                  });
                }

                productDetail.isFav = !productDetail.isFav;
                setState(() {});
              },
              icon: Icon(
                productDetail.isFav
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: mainColor,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  _showTaost(bool isFav) {
    Fluttertoast.showToast(
      msg: isFav
          ? "Favorites has been removed"
          : "Added to Favorites successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.withOpacity(0.59),
      textColor: whiteColor,
      fontSize: 15.0,
    );
  }

  List<Widget> _buildDescription() {
    return [
      const Text('Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      ExpandableText(
        productDetail.desc ?? 'No description',
        expandText: 'view more',
        collapseText: 'view less',
        maxLines: 5,
        linkStyle: const TextStyle(
            color: Color(0xFF424242), fontWeight: FontWeight.bold),
      ),
    ];
  }

  Widget _buldFloatBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (GlobalClass().isUserLogin) {
                var total = productDetail.priceOut! + cartCon.shippingCharge;
                var subTotal = productDetail.priceOut!;
                Get.to(
                  () => CheckOutScreen(
                    listPro: [
                      CartModel(
                        product: productDetail,
                        quantity: 1,
                      )
                    ],
                    total: total.toString(),
                    subTotal: subTotal.toString(),
                  ),
                );
              } else {
                Get.to(const LoginScreen());
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: mainColor, width: 1.2),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: mainColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (GlobalClass().isUserLogin) {
                cartCon.addToCart(productDetail);
                Get.back();
              } else {
                Get.to(const LoginScreen());
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: mainColor,
              ),
              alignment: Alignment.center,
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// double getProportionateScreenHeight(double inputHeight) {
//   double screenHeight = globalContext.height;
//   // 812 is the layout height that designer use
//   return (inputHeight / 926.0) * screenHeight;
// }

// // Get the proportionate height as per screen size
// double getProportionateScreenWidth(double inputWidth) {
//   double screenWidth = globalContext.width;
//   // 375 is the layout width that designer use
//   return (inputWidth / 428.0) * screenWidth;
// }
