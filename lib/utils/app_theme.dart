import 'package:flutter/material.dart';
import 'package:pomodoro_timer/utils/constants.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: bgColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
    background: bgColor,
  ),
);
