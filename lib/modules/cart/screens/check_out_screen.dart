import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/modules/profile/screens/address_screen.dart';

import '../../../model/address_model.dart';
import '../../../utils/Utilty.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/primary_button.dart';
import '../components/cart_item.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_model.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen(
      {super.key,
      required this.listPro,
      required this.total,
      required this.subTotal});
  final List<CartModel> listPro;
  final String total;
  final String subTotal;
  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

List<String> pymOptions = [
  'Cash On Delivery',
  'Credit / Debit Card',
].obs;

class _CheckOutScreenState extends State<CheckOutScreen> {
  var currentOpt = pymOptions[0].obs;
  var cartController = Get.put(CartController());
  var address = AddressModel().obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: customAppBar(
          title: "Checkout",
          showNotification: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              buildAddress(),
              const SizedBox(height: 15),
              buildListProduct(),
              const SizedBox(height: 15),
              buildPaymentMethod(),
              const SizedBox(height: 15),
              buildPaymentInfo(),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomPrimaryButton(
            buttonColor: address.value.id == null ? Colors.grey : mainColor,
            textValue: 'Place Order',
            textColor: Colors.white,
            onPressed: () async {
              if (address.value.id != null) {
                loadingDialog();
                await cartController.checkOutOrder(
                  pymType: currentOpt.value,
                  addressId: address.value.id ?? 0,
                  total: cartController.cartTotal,
                  products: cartController.shoppingCart,
                );
                popLoadingDialog();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildAddress() {
    var txtAddress =
        "${address.value.house},${address.value.commune},${address.value.district},${address.value.province}";
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressScreen(
                selectAddress: true,
              ),
            )).then((value) {
          var add = value as AddressModel;
          address.value = add;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/profile/location@2x.png',
                  width: 25,
                ),
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    'Deliver address',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade100,
              ),
              child: Row(
                children: [
                  address.value.id == null
                      ? const SizedBox()
                      : Image.asset(
                          'assets/icons/map.png',
                          width: 30,
                        ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      address.value.id == null ? 'Address' : txtAddress,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListProduct() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Order Details",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          Column(
            children: widget.listPro
                .map(
                  (cartItem) => CartItem(
                    cartItem: cartItem,
                    viewOnly: true,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethod() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icons/profile/wallet@2x.png',
                  scale: 1.5,
                ),
                const SizedBox(width: 15),
                const Text(
                  "Payment Methods",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(pymOptions.length, (index) {
                return RadioListTile<String>(
                  value: pymOptions[index],
                  groupValue: currentOpt.value,
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Text(
                        pymOptions[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        index == 0
                            ? 'assets/icons/cash.png'
                            : 'assets/icons/credit.png',
                        width: index == 0 ? 40 : 50,
                      )
                    ],
                  ),
                  onChanged: (value) {
                    debugPrint('My DebugPrint : ${currentOpt.value}');
                    currentOpt.value = value!;
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPaymentInfo() {
    return SizedBox(
      child: widget.listPro.isNotEmpty
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
                        "\$${widget.subTotal}",
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
                        "\$${widget.total}",
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
