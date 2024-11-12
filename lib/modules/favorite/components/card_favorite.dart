import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/product_model.dart';
import 'package:homework3/modules/home_screen/screens/product_detail.dart';

import '../../cart/controllers/cart_controller.dart';
import '../../../widgets/CustomCachedNetworkImage.dart';

class CardFavorite extends StatefulWidget {
  const CardFavorite({
    Key? key,
    required this.product,
    this.showShadow = true,
  }) : super(key: key);
  final ProductModel product;
  final bool showShadow;
  @override
  State<CardFavorite> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CardFavorite>
    with SingleTickerProviderStateMixin {
  // ignore: prefer_typing_uninitialized_variables
  var con = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        log("Log ${widget.product.productName}");
        Get.to(ProductDetailsView(
          product: widget.product,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffFEFEFE),
          boxShadow: shadow,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black26.withOpacity(0.1),
                        offset: Offset(2, 2),
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: CustomCachedNetworkImage(
                      imgUrl: widget.product.image ?? ''),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.productName ?? '',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.product.categoryName.toString(),
                        style:
                            TextStyle(fontSize: 13, color: Color(0xff8F8F8F)),
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.product.qty}",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("remaning"),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  con.addToCart(
                    widget.product,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        offset: Offset(2, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  width: 45,
                  height: 45,
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    'images/cart.png',
                    width: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
