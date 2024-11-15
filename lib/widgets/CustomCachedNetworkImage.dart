import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homework3/utils/api_base_helper.dart';

import '../constants/Color.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.imgUrl,
  });
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    log(imgUrl);
    return CachedNetworkImage(
      imageUrl: "$baseurl/$imgUrl",
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: mainColor,
          strokeWidth: 1,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        'images/empty.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
