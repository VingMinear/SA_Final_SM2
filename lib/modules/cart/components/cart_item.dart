import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';

class CartItem extends StatefulWidget {
  final CartModel cartItem;
  final bool viewOnly;
  const CartItem({
    super.key,
    required this.cartItem,
    required this.viewOnly,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.viewOnly) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Row(
          children: [
            Container(
              width: size.width * 0.15,
              height: size.width * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: CustomCachedNetworkImage(
                    imgUrl: widget.cartItem.product.image ?? ''),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cartItem.product.productName ?? '',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Text(
                    "\$${widget.cartItem.product.priceOut}",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.030,
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              'x ${widget.cartItem.quantity}',
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.only(bottom: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffFEFEFE),
          boxShadow: shadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width * 0.2,
              height: size.width * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: CustomCachedNetworkImage(
                    imgUrl: widget.cartItem.product.image ?? ''),
              ),
            ),
            SizedBox(
              width: size.width * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cartItem.product.productName ?? '',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Text(
                    "\$${widget.cartItem.product.priceOut}",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: size.width * 0.035,
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.030,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          cartController.incrementQty(widget.cartItem);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Iconsax.add,
                            color: Colors.black,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Text(
                        widget.cartItem.quantity.toString(),
                        style: TextStyle(),
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      GestureDetector(
                        onTap: () {
                          cartController.decrimentQty(widget.cartItem);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red.shade200,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Iconsax.minus,
                            color: Colors.red,
                            size: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                cartController.removeItem(widget.cartItem);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xffff3333),
                    duration: Duration(milliseconds: 550),
                    content: Text(
                      "Item removed!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.redAccent.withOpacity(0.07),
                radius: 20,
                child: const Icon(
                  Iconsax.trash,
                  color: Colors.redAccent,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 0),
          ],
        ),
      );
    }
  }
}
