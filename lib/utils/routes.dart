import 'package:get/get.dart';
import 'package:pomodoro_timer/pages/error_page.dart';
import 'package:pomodoro_timer/pages/home_page.dart';
import 'package:pomodoro_timer/pages/settings_page.dart';
import 'package:pomodoro_timer/utils/dependencies.dart';
import 'package:rate_my_app/rate_my_app.dart';

class Routes {
  static RateMyApp? rateMyApp;
  // static const splash = "/";
  // static const onboarding = "/onboarding";
  static const home = "/home";
  static const settings = "/settings";
  static const error = "/error";

  static List<GetPage> routes = [
    // GetPage(name: splash, page: () => const SplashPage()),
    // GetPage(name: onboarding, page: () => const OnboardingPage(), middlewares: [OnBoardingMiddleWare()]),
    GetPage(name: home, page: () => HomePage(rateMyApp: rateMyApp), binding: Dependencies()),
    GetPage(name: settings, page: () => const SettingsPage()),
    GetPage(name: error, page: () => const ErrorPage()),
  ];

  static setRate(RateMyApp rateApp) {
    rateMyApp = rateApp;
  }
}
