import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:homework3/model/product_model.dart';
import 'package:homework3/modules/auth/screens/login_screen.dart';
import 'package:homework3/modules/cart/controllers/cart_controller.dart';
import 'package:homework3/modules/home_screen/screens/product_detail.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';

class CardProductHorizontal extends StatelessWidget {
  const CardProductHorizontal({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          ProductDetailsView(product: product),
        );
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10).copyWith(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffFEFEFE),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 125),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.productName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    product.desc ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xff8F8F8F)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${product.qty}",
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Text("remaning"),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xffFED352),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (GlobalClass().isUserLogin) {
                            Get.put(CartController()).addToCart(
                              product,
                            );
                          } else {
                            Get.to(const LoginScreen());
                          }
                        },
                        child: Image.asset(
                          'images/cart.png',
                          width: 22,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            child: Container(
              width: 110,
              height: 135,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black45,
                    offset: Offset(0, 0),
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    blurRadius: 0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                    blurStyle: BlurStyle.solid,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CustomCachedNetworkImage(imgUrl: product.image ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}
