import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pomodoro_timer/controllers/pomodoro_controller.dart';
import 'package:pomodoro_timer/pages/home_page.dart';
import 'package:pomodoro_timer/utils/constants.dart';
import 'package:pomodoro_timer/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    prefs = await _prefs;
  }

  void _onIntroEnd(context) {
    prefs.setBool(showOnBoardingKey, false);
    Get.off(HomePage(
      rateMyApp: Get.arguments[0]!,
    ));
  }

  Widget _buildFullscreenImage(String img) {
    return Image.asset(
      img,
      fit: BoxFit.contain,
      height: 260,
      width: 235,
      alignment: Alignment.center,
    );
  }

  Widget _buildButton(String title) {
    return Container(
      width: 150,
      decoration: BoxDecoration(color: Colors.blue[300], borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      child: Center(
        child: SmallText(
          text: title,
          color: Colors.white,
          size: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    var pageDecoration = PageDecoration(
      titleTextStyle: const TextStyle(fontSize: 18, fontFamily: "Tajawal"),
      bodyTextStyle: const TextStyle(fontSize: 14, fontFamily: "Tajawal", height: 2),
      bodyPadding: EdgeInsets.fromLTRB(45, Get.context!.isPortrait ? 65 : 20, 45, 0),
      titlePadding: EdgeInsets.fromLTRB(45, Get.context!.isPortrait ? 65 : 20, 45, 0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return GetBuilder(
        init: Get.find<PomodoroController>(),
        builder: (pomodoroController) {
          return IntroductionScreen(
            key: introKey,
            globalBackgroundColor: Colors.white,
            isTopSafeArea: true,
            rtl: true,
            pages: [
              PageViewModel(
                  title: "اهلا وسهلا بك معانا",
                  body: "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى",
                  image: _buildFullscreenImage("assets/images/logo.png"),
                  decoration: pageDecoration),
              PageViewModel(
                title: "تعدد الامكانيات",
                body: "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى",
                image: _buildFullscreenImage("assets/images/logo.png"),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "سرعة التعامل",
                body: "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى",
                image: _buildFullscreenImage("assets/images/logo.png"),
                decoration: pageDecoration,
              ),
            ],

            onDone: () => _onIntroEnd(context),
            //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
            showSkipButton: true,
            skipOrBackFlex: 0,
            nextFlex: 0,
            // showBackButton: true,
            //rtl: true, // Display as right-to-left
            back: _buildButton("prev".tr),
            skip: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Center(
                child: SmallText(
                  text: "skip".tr,
                  color: Colors.black87,
                  size: 14,
                ),
              ),
            ),
            next: _buildButton("next".tr),
            done: _buildButton("done".tr),
            curve: Curves.fastLinearToSlowEaseIn,
            // controlsMargin: const EdgeInsets.all(16),
            // controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            dotsDecorator: const DotsDecorator(
              size: Size(10, 10),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          );
        });
  }
}
