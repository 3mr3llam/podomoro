import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro_timer/controllers/menu_controller.dart';
import 'package:pomodoro_timer/controllers/pomodoro_controller.dart';
import 'package:pomodoro_timer/pages/privacy_page.dart';
import 'package:pomodoro_timer/pages/settings_page.dart';
import 'package:pomodoro_timer/pages/terms_page.dart';
import 'package:pomodoro_timer/utils/constants.dart';
import 'package:pomodoro_timer/widgets/circular_image.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class MenuPage extends StatefulWidget {
  final RateMyApp rateMyApp;
  const MenuPage({Key? key, required this.rateMyApp}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  PomodoroController podoController = Get.find<PomodoroController>();

  late List<MenuItem> options;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.find<PomodoroController>(),
        builder: (pomodoroController) {
          options = [
            MenuItem(
                icon: Icons.settings,
                title: 'settings'.tr,
                onPress: (context) {
                  Get.find<XMenuController>().toggle();
                  Get.to(() => const SettingsPage());
                }),
            MenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'privacyPolicy'.tr,
                onPress: (context) {
                  Get.find<XMenuController>().toggle();
                  if (!kIsWeb &&
                      (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows)) {
                    _launchURL('https://sites.google.com/view/podomoro-privacy');
                  } else {
                    Get.to(
                      () => const PrivacyPage(),
                    );
                  }
                }),
            MenuItem(
                icon: Icons.line_style_rounded,
                title: 'termsConditions'.tr,
                onPress: (context) {
                  Get.find<XMenuController>().toggle();
                  if (!kIsWeb &&
                      (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows)) {
                    _launchURL('https://sites.google.com/view/podomoro-terms');
                  } else {
                    Get.to(
                      () => const TermsPage(),
                    );
                  }
                }),
            MenuItem(
                icon: Icons.share_outlined,
                title: 'share'.tr,
                onPress: (context) async {
                  Get.find<XMenuController>().toggle();
                  final box = context.findRenderObject() as RenderBox?;

                  await Share.share(
                    '${'checkThisApp'.tr} https://play.google.com/store/apps/details?id=$googlePlayIdentifier',
                    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                  );
                }),
          ];

          if (!kIsWeb && !Platform.isWindows) {
            options.add(
              MenuItem(
                icon: Icons.star_rate_outlined,
                title: 'rateUs'.tr,
                onPress: (context) {
                  Get.find<XMenuController>().toggle();
                  widget.rateMyApp.showStarRateDialog(context,
                      title: 'rateThisApp'.tr, message: 'rateThisAppMessage'.tr, starRatingOptions: const StarRatingOptions(initialRating: 4), actionsBuilder: actionBuilder);
                },
              ),
            );
          }
          return GestureDetector(
            onPanUpdate: (details) {
              //on swiping left
              if (details.delta.dx < -6) {
                Get.find<XMenuController>().toggle();
              }
            },
            child: GestureDetector(
              onTap: () => Get.find<XMenuController>().toggle(),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: Get.locale!.languageCode == 'ar'
                    ? const EdgeInsets.only(top: 62, left: 32, bottom: 8, right: 32)
                    : EdgeInsets.only(top: 62, left: 32, bottom: 8, right: MediaQuery.of(context).size.width / 2.9),
                color: bgColor, //const Color(0xff454dff),
                child: ListView(
                  children: <Widget>[
                    Row(
                      textDirection: Get.locale!.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                      children: <Widget>[
                        Padding(
                          padding: Get.locale!.languageCode == 'ar' ? const EdgeInsets.only(left: 16) : const EdgeInsets.only(right: 16),
                          child: const CircularImage(
                            AssetImage('assets/images/logo.png'),
                          ),
                        ),
                        const Text(
                          appName,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: options.map((item) {
                        return Ink(
                          child: ListTile(
                            onTap: () {
                              item.onPress(context);
                            },
                            leading: Icon(
                              item.icon,
                              color: whiteColor,
                              size: 20,
                            ),
                            title: Text(
                              item.title,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: whiteColor),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _launchURL(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.inAppWebView,
    );
  }

  List<Widget> actionBuilder(BuildContext context, double? stars) {
    return stars == null ? [buildCancelButton()] : [buildOkButton(), buildCancelButton()];
  }

  Widget buildOkButton() {
    return RateMyAppRateButton(widget.rateMyApp, text: 'ok'.tr);
  }

  Widget buildCancelButton() {
    return RateMyAppNoButton(widget.rateMyApp, text: 'no'.tr);
  }
}

class MenuItem {
  String title;
  IconData icon;
  Function(BuildContext context) onPress;

  MenuItem({required this.icon, required this.title, required this.onPress});
}
