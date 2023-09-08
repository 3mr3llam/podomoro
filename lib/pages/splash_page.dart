import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/pages/home_page.dart';
import 'package:pomodoro_timer/pages/onboarding_page.dart';
import 'package:pomodoro_timer/utils/constants.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  final RateMyApp rateMyApp;

  const SplashPage({Key? key, required this.rateMyApp}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  void initPrefs() async {
    prefs = await _prefs;
  }

  @override
  void initState() {
    super.initState();
    initPrefs();

    Timer(const Duration(milliseconds: 1500), () {
      if (prefs.containsKey(showOnBoardingKey) && prefs.getBool(showOnBoardingKey)!) {
        Get.off(() => const OnboardingPage(), arguments: [widget.rateMyApp]);
      } else {
        Get.off(() => HomePage(rateMyApp: widget.rateMyApp));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          height: 80,
          width: 80,
        ),
      ),
    );
  }
}
