import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:homework3/constants/color.dart';
import 'package:homework3/model/address_model.dart';
import 'package:homework3/modules/profile/screens/add_address_screen.dart';
import 'package:homework3/utils/Utilty.dart';

import '../../../widgets/custom_appbar.dart';
import '../../../widgets/primary_button.dart';
import '../controller/address_controller.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key, this.selectAddress = false});
  final con = Get.put(AddressController());
  final bool selectAddress;
  @override
  Widget build(BuildContext context) {
    con.getAddress();
    return Scaffold(
      appBar: customAppBar(
        title: 'Address',
        showNotification: false,
      ),
      body: Obx(
        () {
          return con.loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : con.listAddress.isEmpty
                  ? const Center(child: Text('No Address found.'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(20),
                            itemCount: con.listAddress.length,
                            itemBuilder: (context, index) {
                              var item = con.listAddress[index];
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        alertDialogConfirmation(
                                          title: 'Are you sure?',
                                          desc:
                                              'You want to delete this address?',
                                          onConfirm: () async {
                                            Get.back();
                                            await con.deleleAddress(item.id!);
                                          },
                                        );
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        left: Radius.circular(10),
                                      ),
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        Get.to(AddAddressScreen(
                                          addNew: false,
                                          address: item,
                                        ));
                                      },
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        right: Radius.circular(10),
                                      ),
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectAddress) {
                                      Navigator.pop(context, item);
                                    } else {
                                      Get.to(AddAddressScreen(
                                        addNew: false,
                                        address: item,
                                      ));
                                    }
                                  },
                                  child: buildAddress(item),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                          ),
                        ],
                      ),
                    );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomPrimaryButton(
          textValue: 'Add Address',
          textColor: Colors.white,
          onPressed: () async {
            Get.to(AddAddressScreen(
              addNew: true,
            ));
          },
        ),
      ),
    );
  }

  Widget buildAddress(AddressModel item) {
    var address =
        "${item.house},${item.commune},${item.district},${item.province}";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: shadow,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Image.asset(
              'assets/icons/map.png',
              width: 40,
            ),
            title: Text(
              "${item.receiverName} ${item.phoneNumber}",
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              address,
            ),
          )
        ],
      ),
    );
  }
}
