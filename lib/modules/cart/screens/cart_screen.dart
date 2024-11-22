import 'package:animate_do/animate_do.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/cart/controllers/cart_controller.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../components/cart_item.dart';
import 'check_out_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.back = false});
  final bool back;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(
        title: "My Cart",
        useLeadingCustom: widget.back,
        showNotification: false,
      ),
      body: GetBuilder<CartController>(builder: (cartController) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: cartController.shoppingCart.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: cartController.shoppingCart
                                    .map(
                                      (cartItem) => CartItem(
                                        cartItem: cartItem,
                                        viewOnly: false,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          )
                        : Center(
                            child: FadeInUp(
                              from: 10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.25,
                                  ),
                                  Image.asset(
                                    'images/cart.png',
                                    width: 80,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.020,
                                  ),
                                  const Text(
                                    "Your cart is empty!",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              SizedBox(
                child: cartController.shoppingCart.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order Info",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.040,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.010,
                          ),
                          buildPaymentInfo(cartController),
                          SizedBox(
                            height: size.height * 0.010,
                          ),
                          SizedBox(
                            width: size.width,
                            height: size.height * 0.055,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => CheckOutScreen(
                                      listPro: cartController.shoppingCart,
                                      subTotal: cartController
                                          .cartSubTotal.formatCurrency,
                                      total: cartController
                                          .cartTotal.formatCurrency,
                                    ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Checkout (\$${cartController.cartTotal})",
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildPaymentInfo(CartController cartController) {
    return SizedBox(
      child: cartController.shoppingCart.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sub Total",
                        style: TextStyle(),
                      ),
                      Text(
                        "\$${cartController.cartSubTotal.formatCurrency}",
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Shipping",
                        style: TextStyle(),
                      ),
                      Text(
                        "+\$${cartController.shippingCharge}",
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tax ",
                        style: TextStyle(),
                      ),
                      Text(
                        "0%",
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: DottedDecoration(
                      dash: const [4],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "\$${cartController.cartTotal.formatCurrency}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
