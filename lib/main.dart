import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/controllers/locale_controller.dart';
import 'package:pomodoro_timer/controllers/pomodoro_controller.dart';
import 'package:pomodoro_timer/firebase_options.dart';
import 'package:pomodoro_timer/notification_service.dart';
import 'package:pomodoro_timer/pages/error_page.dart';
import 'package:pomodoro_timer/pages/splash_page.dart';
import 'package:pomodoro_timer/utils/app_theme.dart';
import 'package:pomodoro_timer/utils/constants.dart';
import 'package:pomodoro_timer/utils/dependencies.dart';
import 'package:pomodoro_timer/utils/languages.dart';
import 'package:pomodoro_timer/utils/routes.dart';
import 'package:pomodoro_timer/widgets/rate_app_init.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.lazyPut(() => PomodoroController(), fenix: true);
  init();
  var notifyHelper = NotifyHelper(null);
  notifyHelper.initializeNotification();
  notifyHelper.requestIOSPermissions();

  runApp(MyApp());
}

// Todo Remember to add this in the descrription
// <a href="https://www.freepik.com/free-vector/404-error-abstract-concept-illustration_11668755.htm#query=error&position=2&from_view=keyword">Image by vectorjuice</a> on Freepik
// Sound Effect by <a href="https://pixabay.com/users/studioalivioglobal-28281460/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=music&amp;utm_content=123742">StudioAlivioGlobal</a> from <a href="https://pixabay.com//?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=music&amp;utm_content=123742">Pixabay</a>
class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final LocaleController localeController = Get.find<LocaleController>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RateAppInit(
      builder: (rateMyApp) {
        Routes.setRate(rateMyApp);
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return ErrorPage(errorDetails: errorDetails);
        };
        return GetMaterialApp(
            navigatorKey: MyApp.navigatorKey,
            title: appName,
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: localeController.intialLang,
            fallbackLocale: const Locale('en'),
            theme: appTheme,
            home: SplashPage(rateMyApp: rateMyApp),
            initialBinding: Dependencies(),
            // initialRoute: Routes.home,
            unknownRoute: GetPage(name: Routes.error, page: () => const ErrorPage()),
            getPages: Routes.routes,
            defaultTransition: Transition.circularReveal,
            transitionDuration: const Duration(milliseconds: 650),
            builder: (context, widget) {
              return ResponsiveWrapper.builder(
                ClampingScrollWrapper.builder(context, widget!),
                breakpoints: const [
                  ResponsiveBreakpoint.resize(350, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(600, name: TABLET),
                  ResponsiveBreakpoint.resize(800, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
                ],
              );
            });
      },
    );
  }
}
