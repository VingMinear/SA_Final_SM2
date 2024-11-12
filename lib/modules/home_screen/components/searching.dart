import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework3/modules/home_screen/controller/product_controller.dart';
import 'package:homework3/modules/home_screen/screens/list_product.dart';
import 'package:homework3/utils/Utilty.dart';

class Searching extends StatefulWidget {
  Searching({super.key});

  @override
  State<Searching> createState() => _SearchingState();
}

class _SearchingState extends State<Searching> {
  final txtCon = TextEditingController().obs;
  var listProduct = <String>[];
  var con = Get.put(ProductController());
  @override
  void initState() {
    listProduct = con.listSearch;
    super.initState();
  }

  var focus = FocusNode();
  searchCategory(String query) {
    if (query.trim().length < 2) {
      listProduct = con.listSearch.where((element) {
        return element.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      var listTmep = <String>[];
      for (var element in con.productsRecommend) {
        if (element.productName!.toLowerCase().contains(query.toLowerCase())) {
          listTmep.add(element.productName!);
        }
      }
      listProduct = listTmep;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
          leading: Padding(
            padding: EdgeInsets.only(top: 10),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
              ),
              color: Colors.black,
            ),
          ),
          title: Container(
            height: 50,
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              controller: txtCon.value,
              autocorrect: true,
              autofocus: true,
              focusNode: focus,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                searchCategory(value);
              },
              onSubmitted: (value) {
                if (value.isEmpty) {
                  showTaost('Please input text to search..');
                } else {
                  Get.to(
                    () => ListProducts(
                      title: value,
                      searchText: value,
                    ),
                  )!
                      .then((value) {
                    focus.requestFocus();
                  });
                }
              },
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                hintText: "Search...",
                suffixIcon: txtCon.value.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          txtCon.value.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FadeIn(
                child: ListView.builder(
                  itemCount: listProduct.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      onTap: () {
                        txtCon.value.text = listProduct[index];
                        Future.delayed(
                          const Duration(milliseconds: 500),
                          () {
                            setState(() {});
                          },
                        );
                        Get.to(
                          () => ListProducts(
                            title: listProduct[index],
                            searchText: listProduct[index],
                          ),
                        )!
                            .then((value) {
                          focus.requestFocus();
                        });
                      },
                      title: Text(listProduct[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
