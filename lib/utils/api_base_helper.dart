import 'dart:convert';

import 'package:get/get_connect.dart';
import 'package:homework3/utils/SingleTon.dart';
import 'package:http/http.dart' as http;

class ErrorModel {
  final int? statusCode;
  final dynamic bodyString;
  const ErrorModel({this.statusCode, this.bodyString});
}

enum METHODE {
  get,
  post,
  delete,
  update,
}

String baseurl = "http://10.0.2.2:8080/";
// final String baseurl = "http://192.168.3.2:8080/";

class ApiBaseHelper extends GetConnect {
  Future<dynamic> onNetworkRequesting({
    required String url,
    Map<String, String>? header,
    Map<String, dynamic>? body,
    required METHODE? methode,
    bool isUploadImage = false,
    bool isEndpoinAdmin = true,
  }) async {
    var addOn = '';
    if (GlobalClass().user.value.isAdmin && isEndpoinAdmin) {
      addOn = 'admin-';
    }
    if (baseurl.startsWith("http://10.0.2.2:8080/")) {
      await Future.delayed(
        const Duration(milliseconds: 300),
        () {},
      );
    }
    final fullUrl = baseurl + 'api/' + "$addOn$url";

    try {
      switch (methode) {
        case METHODE.get:
          final response = await get(
            fullUrl,
          );
          return _returnResponse(response);
        case METHODE.post:
          if (body != null) {
            final response = await post(fullUrl, json.encode(body));
            return _returnResponse(response);
          }
          return Future.error(
              const ErrorModel(bodyString: 'Body must be included'));
        default:
          break;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> postAsyncImage({
    required Map<String, String>? header,
    required String url,
    required String dataImage,
  }) async {
    dynamic dataResponse;

    //Request
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        dataImage,
      ),
    );
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      print(data);
      dataResponse = await json.decode(data);
    }

    return dataResponse;
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.bodyString!);
        return responseJson;
      case 201:
        var responseJson = json.decode(response.bodyString!);
        return responseJson;
      case 202:
        var responseJson = json.decode(response.bodyString!);
        return responseJson;
      case 404:
        return Future.error(ErrorModel(
            statusCode: response.statusCode,
            bodyString: json.decode(response.bodyString!)));
      case 400:
        return Future.error(ErrorModel(
            statusCode: response.statusCode,
            bodyString: json.decode(response.bodyString!)));
      case 401:
      case 403:
        return Future.error(ErrorModel(
            statusCode: response.statusCode,
            bodyString: json.decode(response.bodyString!)));
      case 500:
        break;
      default:
        return Future.error(ErrorModel(
            statusCode: response.statusCode,
            bodyString: json.decode(response.bodyString!)));
    }
  }
}
