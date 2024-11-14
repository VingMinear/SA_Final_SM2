import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/cart/screens/success_order.dart';
import 'package:homework3/utils/Utilty.dart';

import '../../../model/product_model.dart';
import '../../../utils/Date.dart';
import '../../../utils/SingleTon.dart';
import '../../../utils/api_base_helper.dart';
import '../models/cart_model.dart';

class CartController extends GetxController {
  var shoppingCart = <CartModel>[].obs;
  final _apiBaseHelper = ApiBaseHelper();
  void addToCart(ProductModel product) {
    showTaost('Product has been added to cart');
    var isExist = shoppingCart
        .where((element) => element.product.productId == product.productId);
    if (isExist.isEmpty) {
      shoppingCart.add(CartModel(
        product: product,
        quantity: 1,
      ));
    } else {
      isExist.first.quantity += 1;
    }
    update();
  }

  Future<void> checkOutOrder({
    required double total,
    required int addressId,
    required String pymType,
    required List<CartModel> products,
  }) async {
    try {
      var currentDate = Date.dateTime(Date.currentDate());
      await _apiBaseHelper
          .onNetworkRequesting(url: 'add-order', methode: METHODE.post, body: {
        "customer_id": GlobalClass().userId,
        "customer_name": GlobalClass().user.value.name,
        "status_id": 1,
        "device_id": GlobalClass().deviceId,
        "payment_type": pymType,
        "seller": "customer",
        "discount": 0,
        "currentDate": currentDate,
        "total_amount": total,
        "address_id": addressId,
        "products": products.map((e) {
          return {
            "product_id": e.product.productId,
            "qty": e.quantity,
            "price": e.product.priceOut,
          };
        }).toList(),
      }).then((value) {
        if (value['code'] == 200) {
          shoppingCart.clear();
          update();
          Get.off(const SuccessScreenOrder());
        } else {
          alertDialog(desc: value['product'] ?? '');
        }
      });
    } catch (error) {
      Get.back();
      debugPrint(
        'CatchError when checkOutOrder this is error : >> $error',
      );
    }
  }

  void removeItem(CartModel productId) {
    shoppingCart.removeWhere((element) => element == productId);
    update();
  }

  void incrementQty(CartModel productId) {
    CartModel item =
        shoppingCart.where((element) => element == productId).first;
    item.quantity++;
    update();
  }

  void decrimentQty(CartModel productId) {
    CartModel item =
        shoppingCart.where((element) => element == productId).first;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      shoppingCart.remove(item);
    }
    update();
  }

  double getCartTotal() {
    double total = 0;
    for (var cartItem in shoppingCart) {
      var tol = (cartItem.product.priceOut ?? 0) * (cartItem.quantity);
      total += tol;
    }
    return total;
  }

  double get cartSubTotal => getCartTotal();
  double get shippingCharge => 2;
  double get cartTotal => cartSubTotal + shippingCharge;
}
