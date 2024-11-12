import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/home_screen/screens/list_product.dart';

class MidleText extends StatelessWidget {
  const MidleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Text(
              "I",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            Text(
              " Popular Products",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        GestureDetector(
          // ignore: avoid_returning_null_for_void
          onTap: () {
            Get.to(() => const ListProducts(title: 'All Products'));
          },
          child: const Row(
            children: [
              Text(
                "See all",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 20,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ],
    );
  }
}
