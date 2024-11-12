import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/profile/controller/order_controller.dart';
import 'package:homework3/modules/profile/models/order_model.dart';
import 'package:homework3/widgets/CustomCachedNetworkImage.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../widgets/EmptyProduct.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var con = Get.put(OrderController());
    con.getOrders();
    return Obx(
      () => Scaffold(
        appBar: customAppBar(
          title: 'Order',
          showNotification: false,
        ),
        body: con.loading.value
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: mainColor,
                ),
              )
            : con.listOrder.isEmpty
                ? EmptyProduct(desc: 'No Orders')
                : RefreshIndicator(
                    onRefresh: () async {
                      con.getOrders();
                    },
                    child: AnimationLimiter(
                      child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(20),
                        itemCount: con.listOrder.length,
                        itemBuilder: (context, index) {
                          var item = con.listOrder[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 600),
                            child: FadeInAnimation(
                              child: SlideAnimation(
                                child: cardOrder(size, item),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                      ),
                    ),
                  ),
      ),
    );
  }

  Container cardOrder(Size size, OrderModel data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: shadow,
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order Date: ${data.date}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: data.color,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(5).copyWith(left: 10, right: 10),
                child: Text(
                  '${data.status}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 15),
          Visibility(
            child: Column(
              children: List.generate(data.products!.length, (index) {
                var product = data.products![index];
                return Column(
                  children: [
                    Row(
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
                                imgUrl: product.image ?? ''),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product.productName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Qty : x ${product.qty}",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Price : \$${product.amount}",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: mainColor,
                ),
                padding: EdgeInsets.all(5).copyWith(left: 15, right: 15),
                child: Text(
                  "Total : \$${data.totalAmount}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
