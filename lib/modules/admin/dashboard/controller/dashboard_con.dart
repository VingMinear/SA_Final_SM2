import 'dart:developer';

import 'package:get/get.dart';
import 'package:homework3/modules/admin/order/controller/adorder_controller.dart';

import '../../../../utils/api_base_helper.dart';

class DashboardCon extends GetxController {
  var totalAmount = 0.0.obs;
  var totalOrder = 0.obs;
  var newOrder = 0.obs;
  final _apiBaseHelper = ApiBaseHelper();
  Future<void> fetchOrderTotal() async {
    try {
      //
      var res = await _apiBaseHelper.onNetworkRequesting(
          url: '/admin-home', methode: METHODE.post, body: {});
      if (res['code'] == 200) {
        totalAmount.value = res['order_count'];
      }
    } catch (error) {
      log(
        'CatchError while fetchOrderTotal ( error message ) : >> $error',
      );
    }
  }

  Future<void> fetchDataHome() async {
    totalAmount.value = 0;
    totalOrder.value = 0;
    newOrder.value = 0;
    var con = AdOrderController();
    getOrder(con, 0).then((value) {
      newOrder += value.length;
    });
    await fetchOrderTotal();
    getOrder(con, 3).then((value) {
      for (var item in value) {
        totalAmount.value += item.totalAmount;
      }
      totalOrder += value.length;
    });
  }

  Future<List<AdminOrderModel>> getOrder(
      AdOrderController con, int index) async {
    con.selected(index);
    await con.fetchOrder();
    return con.listOrders;
  }
}
