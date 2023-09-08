import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

double? fontSized32(BuildContext context) {
  return ResponsiveValue(
    context,
    defaultValue: 32.0,
    valueWhen: const [
      Condition.equals(
        name: MOBILE,
        value: 32.0,
      ),
      Condition.largerThan(
        name: MOBILE,
        value: 40.0,
      )
    ],
  ).value;
}
