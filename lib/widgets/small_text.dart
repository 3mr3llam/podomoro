import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  final String fontFamily;
  double size;
  double height;
  TextDirection textDirection;

  SmallText(
      {Key? key, this.color = const Color(0xFFccc7c5), required this.text, this.size = 0, this.fontFamily = "Tajawal", this.height = 1.2, this.textDirection = TextDirection.rtl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        // textDirection: Get.locale!.languageCode == "ar" ? TextDirection.rtl : TextDirection.ltr,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: size == 0 ? 12 : size,
          color: color,
          height: height,
        ));
  }
}
