import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:homework3/model/category.dart';
import 'package:homework3/model/imagemodel.dart';

import '../../../../model/image_model.dart';
import '../../../../model/product_model.dart';
import '../../../../utils/api_base_helper.dart';

class AdminProductController extends GetxController {
  var loading = false.obs;
  var isNotFound = false.obs;
  var selectCateIndex = 0;
  var allProducts = <ProductModel>[].obs;
  var listCategory = [
    Category(ImageModel.instance, "All", 0),
    ...(categoryCon.homeCategries)
  ];
  static final categoryCon = Get.put(CategoryController());

  var txtSearch = TextEditingController();
  Category get selectCate => listCategory[selectCateIndex];
  final _apiBaseHelper = ApiBaseHelper();

  Future<bool> deleteProduct({
    required int pid,
  }) async {
    bool isSuccess = false;
    try {
      await _apiBaseHelper.onNetworkRequesting(
          url: 'delete-products',
          methode: METHODE.post,
          isEndpoinAdmin: false,
          body: {
            "product_id": pid,
          }).then((value) {
        if (value['code'] == 200) {
          isSuccess = true;
        }
      });
    } catch (error) {
      log(
        'CatchError while deleteProduct ( error message ) : >> $error',
      );
    }
    return isSuccess;
  }

  Future<ProductModel> getProductDetail({
    required int pId,
  }) async {
    var result = ProductModel();
    try {
      loading(true);
      await _apiBaseHelper.onNetworkRequesting(
          url: 'products-detail',
          methode: METHODE.post,
          isEndpoinAdmin: false,
          body: {
            "p_id": pId,
          }).then((value) {
        if (value['code'] == 200) {
          result = ProductModel.fromJson(value['data'][0]);
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when getProductDetail this is error : >> $error',
      );
    }
    loading(false);
    return result;
  }

  Future<String> uploadPhoto(String image) async {
    var url = '';
    try {
      await _apiBaseHelper.postAsyncImage(
          header: {},
          url: baseurl + 'api/' + "upload",
          dataImage: image).then((value) {
        if (value['code'] == 200) {
          url = value['profile'];
        }
      });
    } catch (error) {
      log(
        'CatchError while uploadPhoto ( error message ) : >> $error',
      );
    }
    return url;
  }

  Future<void> addProduct(
      {required String pname,
      required double priceIn,
      required double priceout,
      required int qty,
      required ImageModel image,
      required int categoryId}) async {
    try {
      var img = '';
      if (image.photoViewBy == PhotoViewBy.file &&
          image.image.value.isNotEmpty) {
        await uploadPhoto(image.image.value).then((value) {
          img = value;
        });
      }

      await _apiBaseHelper
          .onNetworkRequesting(
        url: 'add-products',
        body: image.photoViewBy == PhotoViewBy.file
            ? {
                "product_name": pname,
                "qty": qty,
                "category_id": categoryId,
                "image": img,
                "price_in": priceIn,
                "price_out": priceout
              }
            : {
                "product_name": pname,
                "qty": qty,
                "category_id": categoryId,
                "price_in": priceIn,
                "price_out": priceout
              },
        isEndpoinAdmin: false,
        methode: METHODE.post,
      )
          .then((value) {
        if (value['code'] == 200) {}
      });
    } catch (error) {
      log(
        'CatchError while addProduct ( error message ) : >> $error',
      );
    }
  }

  Future<void> updateProduct(
      {required int pid,
      required String pname,
      required double priceIn,
      required double priceout,
      required int qty,
      required ImageModel image,
      required int categoryId}) async {
    try {
      var img = image.image.value.replaceAll("${baseurl}image/", '');
      if (image.photoViewBy == PhotoViewBy.file &&
          image.image.value.isNotEmpty) {
        await uploadPhoto(image.image.value).then((value) {
          img = value;
        });
      } else if (!image.image.contains(baseurl)) {}

      await _apiBaseHelper
          .onNetworkRequesting(
        url: 'update-products',
        body: {
          "product_id": pid,
          "product_name": pname,
          "qty": qty,
          "category_id": categoryId,
          "image": img,
          "price_in": priceIn,
          "price_out": priceout
        },
        isEndpoinAdmin: false,
        methode: METHODE.post,
      )
          .then((value) {
        if (value['code'] == 200) {}
      });
    } catch (error) {
      log(
        'CatchError while addProduct ( error message ) : >> $error',
      );
    }
  }

  Future<List<ProductModel>> fetchProduct() async {
    var products = <ProductModel>[];
    loading(true);
    try {
      var body = <String, dynamic>{"search": txtSearch.text.trim()};
      var url = 'products';
      if (selectCate.id != 0) {
        url = "products-category";
        body = {"categoryId": selectCate.id, "search": txtSearch.text.trim()};
      }
      await _apiBaseHelper
          .onNetworkRequesting(
        url: url,
        body: body,
        isEndpoinAdmin: false,
        methode: METHODE.post,
      )
          .then((value) {
        if (value['code'] == 200) {
          for (var item in value['data']) {
            products.add(ProductModel.fromJson(item));
          }
        }
      });
    } catch (error) {
      debugPrint(
        'CatchError when getAllProducts this is error : >> $error',
      );
    }
    allProducts.clear();
    allProducts.value = products.toList();
    loading(false);
    return products;
  }
}
