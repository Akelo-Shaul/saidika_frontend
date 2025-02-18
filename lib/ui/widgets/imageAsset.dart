import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saidika_ui/utils/constants.dart';

class imageAsset extends StatelessWidget {
  String fileName;
  double? imgHeight, imgWidth;
  bool isNormalImage;

  imageAsset({
    super.key,
    required this.fileName,
    this.imgHeight,
    this.imgWidth,
    required this.isNormalImage,
  });

  @override
  Widget build(BuildContext context) {
    return isNormalImage == true
        ? Image.asset(
      "$imagePath$fileName",
      height: imgHeight ?? 20,
      width: imgWidth ?? 20,
      fit: BoxFit.fill,

    )
        : SvgPicture.asset(
      "$imagePath$fileName",
      height: imgHeight ?? 20,
      width: imgWidth ?? 20,
    );
  }
}
