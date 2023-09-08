import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  Locale intialLang = const Locale("en");

  LocaleController();

  @override
  void onInit() async {
    super.onInit();
    prefs = await _prefs;
    intialLang = prefs.containsKey(langCodeKey) ? Locale(prefs.getString(langCodeKey)!) : const Locale('en');
    // print(intialLang);
    Get.updateLocale(intialLang);
  }

  void changeLanguage(String langCode) {
    Locale locale = Locale(langCode);
    prefs.setString(langCodeKey, locale.languageCode);
    Get.updateLocale(locale);
  }
}
